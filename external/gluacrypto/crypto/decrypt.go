package gluacrypto_crypto

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/des"
	"encoding/hex"
	"errors"

	lua "github.com/yuin/gopher-lua"
)

// PKCS5Unpadding unpad data
func PKCS5Unpadding(origData []byte) []byte {
	length := len(origData)
	unpadding := int(origData[length-1])
	return origData[:(length - unpadding)]
}

// Decrypt data by specified method: `des-ecb`, `des-cbc`, `aes-cbc`
func Decrypt(data []byte, method string, key, iv []byte) ([]byte, error) {
	var out []byte
	switch method {
	case "des-ecb":
		block, err := des.NewCipher([]byte(key))
		if err != nil {
			return nil, err
		}

		bs := block.BlockSize()
		if len(data)%bs != 0 {
			return nil, errors.New("crypto/cipher: input not full blocks")
		}

		out = make([]byte, len(data))
		dst := out
		for len(data) > 0 {
			block.Decrypt(dst, data[:bs])
			data = data[bs:]
			dst = dst[bs:]
		}
		out = PKCS5Unpadding(out)
	case "des-cbc":
		block, err := des.NewCipher([]byte(key))
		if err != nil {
			return nil, err
		}

		// CBC mode always works in whole blocks.
		if len(data)%block.BlockSize() != 0 {
			return nil, ErrCiphertextNotMultipleBlockSize
		}

		mode := cipher.NewCBCDecrypter(block, []byte(iv))
		plaintext := make([]byte, len(data))
		mode.CryptBlocks(plaintext, data)
		out = PKCS5Unpadding(plaintext)
	case "aes-cbc":
		block, err := aes.NewCipher([]byte(key))
		if err != nil {
			return nil, err
		}

		// CBC mode always works in whole blocks.
		if len(data)%block.BlockSize() != 0 {
			return nil, ErrCiphertextNotMultipleBlockSize
		}

		mode := cipher.NewCBCDecrypter(block, []byte(iv))
		plaintext := make([]byte, len(data))
		mode.CryptBlocks(plaintext, data)
		out = PKCS5Unpadding(plaintext)
	default:
		return nil, ErrNotSupport
	}
	return out, nil
}

func decryptFn(L *lua.LState) int {
	s := lua.LVAsString(L.Get(1))
	method := lua.LVAsString(L.Get(2))
	key := lua.LVAsString(L.Get(3))
	options := L.ToInt(4)
	iv := lua.LVAsString(L.Get(5))

	var data []byte
	var err error
	if options&RawData == 0 {
		data, err = hex.DecodeString(s)
	} else {
		data = []byte(s)
	}
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}

	out, err := Decrypt(data, method, []byte(key), []byte(iv))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}

	L.Push(lua.LString(out))
	return 1
}
