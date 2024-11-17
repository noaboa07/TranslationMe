# Project 6 - *TranslationMe*

Submitted by: **Noah Russell** ZNumber: **Z23667779**

**TranslationMe** is an app that allows users to translate text and speech between a variety of languages. The app provides an intuitive interface where users can enter text, select source and target languages, and view translation results in real-time. Additionally, users can listen to the translated text through a "read aloud" button for better accessibility. The app stores translation history and allows users to manage it easily by clearing translation history if necessary.

Time spent: **5** hours spent in total

## Required Features

The following **required** functionality is completed:

- [✅︎] Users open the app to a TranslationMe home page with a place to enter a word, phrase or sentence, a button to translate, and another field that should initially be empty
- [✅︎] When users tap translate, the word written in the upper field translates in the lower field. The requirement is only that you can translate from one language to another.
- [✅︎] A history of translations can be stored (in a scroll view in the same screen, or a new screen)
- [✅︎] The history of translations can be erased
 
The following **optional** features are implemented:

- [✅︎] Add a variety of choices for the languages (8 different languages)
- [✅︎] Add UI flair

The following **additional** features are implemented:

- [✅︎]  Error handling for translation failures and issues with history retrieval.
- [✅︎] AV Speech: Users can listen to the translated text with a "read aloud" button, improving accessibility by allowing the app to read the translated text out loud.
- [✅︎] The app saves translation history to Firestore and displays a list of past translations with timestamps.
- [✅︎] clear all translations with a confirmation prompt

## Video Walkthrough

My Video Walkthrough:

<img style="max-width:300px;" src="">

GIF created with VEED.io

## Notes

Some challenges encountered while building the app included working with Firestore for storing and retrieving translations. Ensuring that the UI remained responsive during translation requests, as well as managing loading states for smoother user experience, also required some attention. The language picker and handling translations dynamically were key tasks, and integrating Firebase for persistence helped make the app more robust. Additionally, incorporating voice input and AV speech synthesis significantly enhanced the app's accessibility and user experience. Also, I had a lot of trouble with attempting to translate the entire sentence of an input instead of just the first word.

## License

    Copyright [2024] [Noah Russell]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
