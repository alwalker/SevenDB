{
	"inputs": {
		"bucket": "rooms",
		"key_filters":[["string_to_int"], ["less_than", 1000]]
	},
	"query": [
	{"map": {
		"language":"javascript",
		"source":
		"function(v) {
			var parsed_data = JSON.parse(v.values[0].data);
			var data = {};
			data[parsed_data.style] = parsed_data.capacity;
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