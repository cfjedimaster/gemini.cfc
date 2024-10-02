component accessors=true {

	property name="key" type="string";
	property name="model" type="string";

	function init(key, model) {
		if(!arguments.keyExists('key')) cfthrow(message='Key must be passed when component is iniitalized.');
		variables.key=key;
		variables.model=model;
		return this;
	}

	public struct function prompt(string prompt,string model=variables.model) {

		if(!arguments.keyExists("model")) {
			cfthrow(message="If model is not defined at initialization it must be passed as an argument.");
		}

		local.body = {
			"contents": [
				{
					"role": "user",
					"parts": [
						{ "text": arguments.prompt }
					]
				}
			]
		};

		cfhttp(url="https://generativelanguage.googleapis.com/v1beta/models/#arguments.model#:generateContent?key=#variables.key#", method="post", result="local.result") {
			cfhttpparam(type="header", name="Content-Type", value="application/json");
			cfhttpparam(type="body", value="#serializeJSON(body)#");
		}

		return normalizeResult(deserializeJSON(local.result.fileContent));
		

	}

	private struct function normalizeResult(struct r) {
		local.result = {
			"raw":arguments.r
		};

		if(arguments.r.keyExists("candidates") && arguments.r.candidates.len() >= 1) {
			local.result["text"] = arguments.r.candidates[1].content.parts[1].text
		}

		return local.result;

	}

}