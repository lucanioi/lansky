### Engines::AI

#### How it works
It uses Lansky::AI which currently uses OpenAI's GPT-3.5-turbo model to convert user input into function name and parameters. The model is far from perfect, so we need to iron out the kinks.

#### Prompts
The configurations for the function calls are found under 'prompts/operations'. May not be the best word, tbh. But it's more like a prompt than a configuration.

#### Preprocessor
Preprocessor takes the ouput from the AI and converts it into valid operation parameters. It does two things currenty:
1. converts date hash into Lansky::FlexibleDate object as :flex_date
2. converts some common hallucinations into valid operation parameters (there was one with "budget_cents" that drove me insane)
