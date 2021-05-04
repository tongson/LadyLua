package matching

import (
	"strings"

	"github.com/trustelem/zxcvbn/match"
)

type dictionaryMatch struct {
	rankedDictionaries map[string]rankedDictionnary
}

func (dm dictionaryMatch) Matches(password string) []*match.Match {
	var results []*match.Match

	for dictionaryName, rankedDict := range dm.rankedDictionaries {
		for i := range password {
			j := len(password) - 1
			for delta := range password[i:] {
				if delta > 0 {
					j = i + delta - 1
				}
				word := strings.ToLower(password[i : j+1])
				if val, ok := rankedDict[word]; ok {
					matchDic := &match.Match{
						Pattern:        "dictionary",
						I:              i,
						J:              j,
						Token:          password[i : j+1],
						MatchedWord:    word,
						Rank:           val,
						DictionaryName: dictionaryName,
					}

					results = append(results, matchDic)
				}
			}
		}
	}

	match.Sort(results)
	return results
}

func (dm dictionaryMatch) withDict(name string, d rankedDictionnary) dictionaryMatch {
	rd2 := make(map[string]rankedDictionnary, len(dm.rankedDictionaries)+1)
	for k, v := range dm.rankedDictionaries {
		rd2[k] = v
	}
	rd2[name] = d
	return dictionaryMatch{rankedDictionaries: rd2}
}

type rankedDictionnary map[string]int

func buildRankedDict(unrankedList []string) rankedDictionnary {
	result := make(rankedDictionnary)

	for i, v := range unrankedList {
		result[strings.ToLower(v)] = i + 1
	}

	return result
}
