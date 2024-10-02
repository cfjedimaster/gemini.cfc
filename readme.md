# gemini.cfc

This is a lightweight wrapper for Google's [Gemini API](https://ai.google.dev/). It requires a key you can generate at
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
result = gemini.prompt('why is the sky blue?','gemini-1.5-flash');
```

Results are normalized such that you get a result object with:

* raw: Contains the raw response from the API.
* text: The text of the response.

## Changelog

* Oct 1, 2024: Initial Release. To be added next - file upload. 


