#!/bin/bash

SCRIPT="var zxcvbn = require('zxcvbn'); \
var res = []; \
for (var i = 2; i < process.argv.length; i++) { \
    res.push(zxcvbn(process.argv[i])); \
}; \
var now = new Date();
console.log(JSON.stringify({ timestamp: now, tests: res },null,2));"

# echo $SCRIPT
node -e "$SCRIPT" \
"zxcvbn" \
"qwER43@!" \
"Tr0ub4dour&3" \
"correcthorsebatterystaple" \
"coRrecth0rseba++ery9.23.2007staple$" \
\
"p@ssword" \
"p@$$word" \
"123456" \
"123456789" \
"11111111" \
"zxcvbnm,./" \
"love88" \
"angel08" \
"monkey13" \
"iloveyou" \
"woaini" \
"wang" \
"tianya" \
"zhang198822" \
"li4478" \
"a6a4Aa8a" \
"b6b4Bb8b" \
"z6z4Zz8z" \
"aiIiAaIA" \
"zxXxZzXZ" \
"pässwörd" \
"alpha bravo charlie delta" \
"a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9" \
"a b c 1 2 3" \
"correct-horse-battery-staple" \
"correct.horse.battery.staple" \
"correct,horse,battery,staple" \
"correct~horse~battery~staple" \
"WhyfaultthebardifhesingstheArgives’harshfate?" \
"Eupithes’sonAntinousbroketheirsilence" \
"Athena lavished a marvelous splendor" \
"buckmulliganstenderchant" \
"seethenthatyewalkcircumspectly" \
"LihiandthepeopleofMorianton" \
"establishedinthecityofZarahemla" \
"!\"£$%^&*()" \
\
"D0g.................." \
"abcdefghijk987654321" \
"neverforget13/3/1997" \
"1qaz2wsx3edc\"" \
\
"temppass22" \
"briansmith" \
"briansmith4mayor" \
"password1" \
"viking" \
"thx1138" \
"ScoRpi0ns" \
"do you know" \
\
"ryanhunter2000" \
"rianhunter2000" \
\
"asdfghju7654rewq" \
"AOEUIDHG&*()LS_" \
\
"12345678" \
"defghi6789" \
\
"rosebud" \
"Rosebud" \
"ROSEBUD" \
"rosebuD" \
"ros3bud99" \
"r0s3bud99" \
"R0$38uD99" \
\
"verlineVANDERMARK" \
\
"eheuczkqyq" \
"rWibMFACxAUGZmxhVncy" \
"Ba9ZyWABu99[BK#6MBgbH88Tofv)vs$w" \
> output.json
