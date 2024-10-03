# gemini.cfc

This is a lightweight ColdFusion wrapper for Google's [Gemini API](https://ai.google.dev/). It requires a key you can generate at
[AI Studio](https://aistudio.google.com). 

## Usage

Initialize the CFC with your key, and optionally, a model:

```js
gemini = new gemini(key="your key", model="gemini-1.5-pro");
```

If you do not pass a model during creation, you'll need to pass it when using prompts. 

## Evaluating Prompts

To pass a prompt, use the `prompt` method:

```js
result = gemini.prompt('why is the sky blue?');
```

You can also specify a model:

```js
result = gemini.prompt(prompt='why is the sky blue?',model='gemini-1.5-flash');
```

`model` is the third argument, hence me using named arguments above.

Results are normalized such that you get a result object with:

* raw: Contains the raw response from the API.
* text: The text of the response.

## Multimodal Prompts

To use media in your prompts, use the `uploadFile` method, which takes a required path and optional display name. The result is
a file object that can then be used in the `prompt` method, like so:

```js
fileOb = gemini.uploadFile(expandPath('./cat1.png'));

result = gemini.prompt('what is in this picture?', [ fileOb ]);
writedump(result);
```

You can pass as many files as you would like:

```js
fileOb2 = gemini.uploadFile(expandPath('./dog1.png'));
result = gemini.prompt('what is different in these pictures??', [ fileOb, fileOb2 ]);
writedump(result);
```

## Changelog

* Oct 3, 2024: Added uploadFile and support in the prompt method.
* Oct 1, 2024: Initial Release. To be added next - file upload. 


