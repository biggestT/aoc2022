package main

import (
	"bufio"
	"os"
	"unicode"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}
func getPriority(r rune) int {
	if unicode.IsUpper(r) {
		return int(r) - 65 + 27
	}
	return int(r) - 97 + 1
}

func main() {
	f, err := os.Open("input")
	defer f.Close()
	check(err)
	s := bufio.NewScanner(f)
	sum := 0
	groups := [][]rune{}
	sumG := 0
	for s.Scan() {
		l := []rune(s.Text())
		// part 1
		n := len(l)
		cs1 := map[rune]bool{}
		cs2 := map[rune]bool{}
		var c rune
		for i := 0; i < n/2; i++ {
			c1 := l[i]
			c2 := l[n-i-1]
			cs1[c1] = true
			cs2[c2] = true
			if cs2[c1] {
				c = c1
				break
			}
			if cs1[c2] {
				c = c2
				break
			}
		}
		sum += getPriority(c)
		// part 2
		groups = append(groups, l)
		if len(groups) == 3 {
			g := [3]map[rune]bool{{}, {}, {}}
			i := 0
			var cg rune
			for !unicode.IsLetter(cg) {
				for j := 0; j < 3; j++ {
					if len(groups[j]) > i {
						c := groups[j][i]
						g[j][c] = true
						if g[0][c] && g[1][c] && g[2][c] {
							cg = c
							break
						}
					}
				}
				i += 1
			}
			sumG += getPriority(cg)
			groups = [][]rune{}
		}
	}
	println(sum)
	println(sumG)
}
