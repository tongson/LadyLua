package fuzz

import (
	"github.com/trustelem/zxcvbn"
	"unicode/utf8"
)

func Fuzz(data []byte) int {
	password := string(data)

	_ = zxcvbn.PasswordStrength(password, nil)
	if !utf8.ValidString(password) {
		return 0
	}
	return 1
}
