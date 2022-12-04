package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	f, err := os.Open("input")
	defer f.Close()
	check(err)
	s := bufio.NewScanner(f)
	max := [3]int{0, 0, 0}
	cur := 0
	for s.Scan() {
		l := s.Text()
		switch l {
		case "":
			for i, v := range max {
				if cur > v {
					for j := i + 1; j < len(max); j++ {
						max[j] = max[j-1]
					}
					max[i] = cur
					break
				}
			}
			cur = 0
			continue
		default:
			n, e := strconv.Atoi(l)
			check(e)
			cur += n
		}
	}
	sum := 0
	for _, v := range max {
		sum += v
	}
	fmt.Println(sum)
}
