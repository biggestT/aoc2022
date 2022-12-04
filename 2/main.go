package main

import (
	"bufio"
	"os"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

// part 1
var gameScoreA = map[string]int{
	"AX": 1 + 3,
	"AY": 2 + 6,
	"AZ": 3 + 0,
	"BX": 1 + 0,
	"BY": 2 + 3,
	"BZ": 3 + 6,
	"CX": 1 + 6,
	"CY": 2 + 0,
	"CZ": 3 + 3,
}

// part 2
var gameScoreB = map[string]int{
	"AX": 3 + 0,
	"AY": 1 + 3,
	"AZ": 2 + 6,
	"BX": 1 + 0,
	"BY": 2 + 3,
	"BZ": 3 + 6,
	"CX": 2 + 0,
	"CY": 3 + 3,
	"CZ": 1 + 6,
}

func main() {
	f, err := os.Open("input")
	defer f.Close()
	check(err)
	s := bufio.NewScanner(f)
	s.Split(bufio.ScanRunes)
	score := 0
	game := ""
	for s.Scan() {
		c := s.Text()
		switch c {
		case "A", "B", "C", "X", "Y", "Z":
			game += c
		case "\n":
			score += gameScoreB[game]
			game = ""
		}
	}
	score += gameScoreB[game]
	println(score)
}
