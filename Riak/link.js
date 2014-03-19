{
	"inputs": {
		"bucket": "cages",
		"key_filters": [["eq", "2"]]
	},
	"query": [
		{"link": {
			"bucket": "animals",
			"keep": false
		}},
		{"map": {
			"language": "javascript",
			"source": "function(v) {return [v]; }"
		}}
	]
}