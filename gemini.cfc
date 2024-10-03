component accessors=true {

	property name="key" type="string";
	property name="model" type="string";

	function init(key, model) {
		if(!arguments.keyExists('key')) cfthrow(message='Key must be passed when component is iniitalized.');
		variables.key=key;
		variables.model=model;
		return this;
	}

	public struct function prompt(string prompt,array files=[], string model=variables.model) {

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

		if(arguments.files.len() > 0) {
			arguments.files.each(f => {
				// Note, can't use local here cuz... not sure
				body.contents[1].parts.append({
					"fileData": {
			            "fileUri": f.uri,
            			"mimeType": f.mimeType
			          }
				});
			});
		}

		cfhttp(url="https://generativelanguage.googleapis.com/v1beta/models/#arguments.model#:generateContent?key=#variables.key#", method="post", result="local.result") {
			cfhttpparam(type="header", name="Content-Type", value="application/json");
			cfhttpparam(type="body", value="#serializeJSON(body)#");
		}

		return normalizeResult(deserializeJSON(local.result.fileContent));
		

	}

	public function uploadFile(path, displayName="") {
		var mimeType = fileGetMimeType(path);
		var fileSize = getFileInfo(path).size;
		var result = "";

		if(arguments.displayName == "") arguments.displayName = getFileFromPath(path);

		var body  = {
			"file": {
				"display_name":arguments.displayName,
				"mimeType":mimeType
			}
		};

		cfhttp(url="https://generativelanguage.googleapis.com/upload/v1beta/files?key=#variables.key#", method="post", result="result") {
			cfhttpparam(type="header", name="Content-Type", value="application/json");
			cfhttpparam(type="header", name="X-Goog-Upload-Protocol", value="resumable");
			cfhttpparam(type="header", name="X-Goog-Upload-Command", value="start");
			cfhttpparam(type="header", name="X-Goog-Upload-Header-Content-Length", value=fileSize);
			cfhttpparam(type="header", name="X-Goog-Upload-Header-Content-Type", value=mimeType);
			cfhttpparam(type="body", value="#serializeJSON(body)#");
		}

		cfhttp(url=result.responseheader['X-Goog-Upload-URL'], method="put", result="result") {
			cfhttpparam(type="header", name="Content-Length", value=fileSize);
			cfhttpparam(type="header", name="X-Goog-Upload-Offset", value="0");
			cfhttpparam(type="header", name="X-Goog-Upload-Command", value="upload, finalize");
			cfhttpparam(type="file", name="file", file=path);
		}

		return deserializeJSON(result.fileContent).file;

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