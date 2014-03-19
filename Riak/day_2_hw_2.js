{
	"inputs": {
		"bucket": "rooms",
		"key_filters":[["string_to_int"], ["between", 4200, 4399]]
	},
	"query": [
	{"map": {
		"language":"javascript",
		"source":
		"function(v) {
			var parsed_data = JSON.parse(v.values[0].data);
			var data = {};
			data[Math.floor(v.key/100)] = parsed_data.capacity;
			return [data];
		}"
	}},
	{"reduce": {
		"language": "javascript",
		"source":
		"function(v) {
			var totals = {};
			for (var i in v) {
				for (var style in v[i]) {
					if(totals[style]) totals[style] += v[i][style];
					else totals[style] = v[i][style];
				}
			}
			return [totals];
		}"
	}}
	]
}