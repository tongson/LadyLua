package gluacrypto_crypto

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/des"
	"encoding/hex"
	"errors"

	lua "github.com/yuin/gopher-lua"
)

// options const
const (
	RawData = 1 << iota
	// not implement
	// ZeroPadding = 1 << iota
)

// errors
var (
	ErrNotSupport                     = errors.New("unsupported encrypt method")
	ErrCiphertextNotMultipleBlockSize = errors.New("ciphertext is not a multiple of the block size")
)

// PKCS5Padding pad data
func PKCS5Padding(ciphertext []byte, blockSize int) []byte {
	padding := blockSize - len(ciphertext)%blockSize
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)
	return append(ciphertext, padtext...)
}

// Encrypt data by specified method: `des-ecb`, `des-cbc`, `aes-cbc`
func Encrypt(data []byte, method string, key, iv []byte) ([]byte, error) {
	var out []byte
	switch method {
	case "des-ecb":
		block, err := des.NewCipher(key)
		if err != nil {
			return nil, err
		}

		bs := block.BlockSize()
		data := PKCS5Padding(data, bs)
		out = make([]byte, len(data))

		dst := out
		for len(data) > 0 {
			// The message is divided into blocks,
			// and each block is encrypted separately.
			block.Encrypt(dst, data[:bs])
			data = data[bs:]
			dst = dst[bs:]
		}
	case "des-cbc":
		block, err := des.NewCipher(key)
		if err != nil {
			return nil, err
		}

		data := PKCS5Padding(data, block.BlockSize())
		mode := cipher.NewCBCEncrypter(block, iv)
		out = make([]byte, len(data))
		mode.CryptBlocks(out, data)
	case "aes-cbc":
		block, err := aes.NewCipher(key)
		if err != nil {
			return nil, err
		}

		data := PKCS5Padding(data, block.BlockSize())
		mode := cipher.NewCBCEncrypter(block, iv)
		out = make([]byte, len(data))
		mode.CryptBlocks(out, data)
	default:
		return nil, ErrNotSupport
	}
	return out, nil
}

func encryptFn(L *lua.LState) int {
	s := lua.LVAsString(L.Get(1))
	method := lua.LVAsString(L.Get(2))
	key := lua.LVAsString(L.Get(3))
	options := L.ToInt(4)
	iv := lua.LVAsString(L.Get(5))

	out, err := Encrypt([]byte(s), method, []byte(key), []byte(iv))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}

	var result string
	if options&RawData == 0 {
		result = hex.EncodeToString(out)
	} else {
		result = string(out)
	}
	L.Push(lua.LString(result))
	return 1
}
