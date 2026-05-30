# SKILL: Daily Tech Brief and Quiz Generation

## GOAL
Your goal is to generate a highly personalized, high-quality daily tech brief for a user and deliver it via Telegram. The brief must feature exactly 5 tailored interview questions and 3 to 5 interesting technical tidbits based on the user's saved profile.

## CONTEXT
This skill is automatically triggered by a cron job every evening at 9 PM in the user's local timezone. You must independently fetch the user's preferences, research fresh content, generate the brief, and send it.

## GENERATION WORKFLOW
1. **Retrieve User Profile:** Use the `memory_store` tool to fetch the user's saved profile by looking up the key `user_profile_{{user.id}}`. Extract their `domains`, `level`, and `goals`.
2. **Conduct Web Search:** You must invoke the `web_search` tool to find recent, relevant information for each of the user's specified `domains`. Frame your search queries to find fresh news, advanced concepts, or recent updates (e.g., "latest developments in [domain]", "advanced interview questions for [domain]", "recent news [domain]").
3. **Synthesize Tidbits:** Based on the results from the `web_search` tool, synthesize between 3 to 5 interesting technical tidbits. A tidbit should be a short, insightful piece of factual information, a recent news highlight, or a best practice relevant to their domains.
4. **Generate Interview Questions:** Generate exactly 5 interview questions. The questions must adhere to these strict constraints based on the user's profile:
   * **Relevance:** They must be directly related to the user's specified `domains` and `goals`.
   * **Difficulty:** They must be perfectly appropriate for the user's `level` (e.g., avoid deep architectural system design questions for a junior developer unless requested).
   * **Variety:** Provide a well-rounded mix of question types: conceptual, coding/algorithmic, system design, and behavioral/situational.
   * **Novelty:** Ensure the questions feel fresh and challenging.
5. **Format the Message:** Assemble the final message using Telegram's Markdown formatting. The final output must strictly follow this exact layout, including the emojis and horizontal lines:

   ```markdown
   🦞 *Your Daily Tech Brief* — [Current Date]
   
   -------------------------
   🧠 *Interview Questions*
   -------------------------
   
   *Q1 [Question Type — Domain]*
   [Text of Question 1]
   
   *Q2 [Question Type — Domain]*
   [Text of Question 2]
   
   *Q3 [Question Type — Domain]*
   [Text of Question 3]
   
   *Q4 [Question Type — Domain]*
   [Text of Question 4]
   
   *Q5 [Question Type — Domain]*
   [Text of Question 5]
   
   -------------------------
   💡 *Today's Tidbits*
   -------------------------
   
   • [Text of Tidbit 1]
   
   • [Text of Tidbit 2]
   
   • [Text of Tidbit 3]
   
   -------------------------
   Reply *answers* to get feedback, or *more* for extra questions.
   ```

## CONSTRAINTS
- **CRITICAL:** You must use the `web_search` tool to gather fresh information; do not rely solely on your pre-training data for the tidbits.
- **CRITICAL:** There must be exactly 5 questions and between 3 to 5 tidbits.
- Do not include any conversational filler at the beginning or end of the message (e.g., "Here is your brief!"). The output should ONLY be the formatted Markdown message.
- Ensure the message is formatted perfectly for readability on a mobile device using standard Telegram Markdown.
