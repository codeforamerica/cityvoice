# State of the CityVoice

Overview of the current code base, and info for generalizing it

## High-level summary

Essentially, the current voice survey (for abandoned properties) is hard-coded. 

Looking at the code with fresh eyes, it wouldn't be a terrible idea to start with a clean Rails project and build a simpler foundation, now knowing more or less the user experience that seems to work.

A few more notes on the current code base:

1. There's a fair amount of **vestigial code** from previous iterations of the app (for example, the [text_feedback_controller](app/controllers/text_feedback_controller.rb) should probably be removed.)
1. There's also a fair amount of **South Bend-specific code** (for example, as contained in the [manage_deploy_data.rake](lib/tasks/manage_deploy_data.rake) Rake task.)
1. The "subject" of a survey (e.g., a property) is pretty general and reusable, basically being some entity with a latitude/longitude.
1. All the voice (Twilio) code is contained in the [voice_feedback_controller.rb](app/controllers/voice_feedback_controller.rb).
1. The biggest pain point for generalizing for redeployment is going to be allowing arbitrary surveys, since a lot of that is currently hard-coded. I propose a strategy in the next section that I think could work by imposing opinionated limits on what the app can do.

## A proposal for generalization/redeployability

Here's what I think the simplest version of a general, redeployable CityVoice looks like:

1. A redeployer loads in the subjects of a survey by way of a simple CSV importer (via Rake task.) The CSV must contain name (unique), latitude, and longitude fields.
1. A survey can have 1-4 "structured" questions (i.e., a question where you press a number to respond) and 1 voice question
1. A single "structured" question can have 2-4 possible responses. These are stored as attributes of the question model (e.g., response_1_meaning, response_2_meaning, etc.) and a null value means that that particular response is not valid input.
 - Illustrative example: For a "repair or remove" question, `response_1_meaning` would be "Repair", `response_2_meaning` would be "Remove", and both `response_3_meaning` and `response_4_meaning` would be null.
1. Survey questions are configured via a simple web form requiring admin privileges. A redeployer records voice files for their questions, and provides a URL for these voice files. (I wouldn't build an upload feature to S3 up-front, but one could.)
 - If one wanted to further simplify, one could simply do a similar CSV import strategy as with the subjects. Might be a good v1 approach.
1. Every subject has the same survey (i.e., no contingent logic based on users' responses.)
1. The "subject code" (the subject-specific value users enter at the beginning of a call to tell the app which subject they're responding about) should be automatically generated, and have some defined limit (I'd vote 3 digits.) If one really wanted to let this be configurable, I would vote to have the CSV import for subjects allow an optional `call_in_code` column that overrides the default assignment, but would still impose a limit on the characters (a known-limit obviates the need for the user to press "#")
1. In addition to question-specific voice files, the following voice files are required (probably configured by adding URLs via admin web form.) Some of these could have default voice files for reuse:
 - Initial welcome message
 - Prompt asking for the subject-specific code
 - Prompt for people to listen to others' messages
 - Prompt to listen to another message
 - Last message reached
 - Prompt asking for consent to share respondent's phone number with survey owner
 - Error 1 ("sorry, bad input")
 - Error 2 ("sorry, we're having problems, try calling again")
 - Final thank you/goodbye message

## Detailed comments on current code base

### Subjects

A "subject" is a geographic entity about which you're "filling out" a survey. The "subject" in the South Bend case, for example, is an abandoned property. It is represented by the `Subject` model.

A "property" in this code base is a subclass of `Subject`, referring to a South Bend-specific vacant & abandoned property. The only difference between a property and a subject is that each property has has a `PropertyInfoSet`, a model containing a bunch of South Bend-specific data (i.e., the info that appears in the upper left of a property-specific view).

The "subjects" of a survey (e.g., properties) are currently loaded in via a pretty dirty rake script. Because "subject" is pretty general and reusable right now, I'd recommend just adding a Rake task that imports a CSV with the core attributes for subjects (name, latitude, and longitude.)

### Feedback input

A "feedback input" is a clunky name for the model that contains a single "response" to a question. It can have either a `voice_file_url` or 

### Voice interface

The voice interface (ie, the Twilio logic) lives in [voice_feedback_controller.rb](app/controllers/voice_feedback_controller.rb).

### Configuration via the AppContentSet

A limited number of CMS-like configuration options are stored in the `AppContentSet` model.