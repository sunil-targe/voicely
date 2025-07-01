//
//  Constants.swift
//  voicely
//
//  Created by Sunil Targe on 2025/6/27.
//

import Foundation

public enum Constants {
    
    public static let stories: [String] = [
        """
        The Tortoise and the Hare:
        The speedy hare mocked the slow tortoise and challenged him to a race.
        Confident of winning, the hare took a nap mid-race.
        Meanwhile, the tortoise kept moving steadily and crossed the finish line.
        Moral: Slow and steady wins the race.
        """,
        
        """
        The Lion and the Mouse:
        A lion spared a tiny mouse that had begged for mercy.
        Later, the lion got trapped in a hunter's net.
        The mouse returned and gnawed the ropes to free him.
        Moral: Even the smallest friend can be the greatest help.
        """,
        
        """
        The Boy Who Cried Wolf:
        A shepherd boy kept falsely crying "Wolf!" to fool the villagers.
        They came running — only to find no wolf.
        One day, a real wolf came, but no one believed him.
        Moral: Liars are not believed even when they speak the truth.
        """,
        
        """
        The Golden Touch (King Midas):
        King Midas wished that everything he touched would turn to gold.
        His wish was granted, but soon even his food and daughter turned to gold.
        He begged the gods to reverse it.
        Moral: Greed can be dangerous and lead to regret.
        """,
        
        """
        The Thirsty Crow:
        A crow found a pot with very little water.
        He dropped pebbles one by one until the water rose.
        He drank and flew away happily.
        Moral: Where there is a will, there is a way.
        """,
        
        """
        Little Red Riding Hood:
        A girl goes to visit her grandmother with food.
        A cunning wolf eats the grandma and dresses up as her.
        The girl notices something strange, and a hunter saves them both.
        Moral: Always be cautious and never talk to strangers.
        """,
        
        """
        The Fox and the Grapes:
        A fox tried to reach grapes hanging high but failed.
        Frustrated, he walked away saying, "They're probably sour anyway."
        Moral: It's easy to despise what you cannot have.
        """,
        
        """
        The Ant and the Grasshopper:
        All summer, the ant worked while the grasshopper sang.
        Winter came, and the grasshopper had nothing.
        The ant survived with stored food.
        Moral: Prepare today for tomorrow's needs.
        """,
        
        """
        The Goose That Laid Golden Eggs:
        A farmer had a goose that laid a golden egg daily.
        He grew greedy and killed the goose, hoping to get all the gold inside.
        But found nothing.
        Moral: Greed destroys good fortune.
        """,
        
        """
        The Honest Woodcutter:
        A poor woodcutter dropped his axe in a river.
        A god offered him a golden axe, then a silver one — he refused both.
        He only accepted his own iron axe.
        Impressed by his honesty, the god gave him all three.
        Moral: Honesty is always rewarded.
        """
    ]
    
    // List of inappropriate words to filter
    public static let jokes: [String] = [
        "Why don't skeletons fight each other?\nBecause they don't have the guts!",
        
        "Why did the scarecrow win an award?\nBecause he was outstanding in his field!",
        
        "What do you call cheese that isn't yours?\nNacho cheese!",
        
        "Why can't your nose be 12 inches long?\nBecause then it would be a foot.",
        
        "What did the ocean say to the beach?\nNothing, it just waved.",
        
        "Why did the tomato blush?\nBecause it saw the salad dressing!",
        
        "What do you call a fish wearing a bowtie?\nSofishticated.",
        
        "How do you organize a space party?\nYou planet.",
        
        "What did one wall say to the other wall?\nI'll meet you at the corner!",
        
        "Why was the math book sad?\nBecause it had too many problems."
    ]
    
    public static let nightStories: [String: [String]] = [
        "English": [
            """
                The Little Engine That Could:
                Once, a tiny blue engine was asked to pull a heavy train over a mountain. All the big engines refused. The little engine said, "I think I can, I think I can," and slowly began to climb. Puffing hard, she reached the top and said, "I knew I could!" A story of perseverance and belief.
                """,
                """
                Paul Bunyan:
                Paul Bunyan was a giant lumberjack with a big blue ox named Babe. Wherever he stepped, lakes formed. He cleared forests with one swing of his axe. People say he made the Grand Canyon by dragging his axe behind him. He represents the strength and myth of the American frontier.
                """,
                """
                The Giving Tree:
                A little boy loved a tree. He played in her branches and rested in her shade. As he grew, he took her apples, then her branches, then her trunk — until nothing remained but a stump. In the end, the boy, now old, sat on the stump, and the tree was happy.
                """,
                """
                Goldilocks and the Three Bears:
                Goldilocks wandered into a cottage in the forest. She tasted three bowls of porridge—one too hot, one too cold, and one just right. She sat in chairs and tested beds the same way. When the bear family returned, she ran away, never to return again!
                """,
                """
                The Tortoise and the Hare:
                A speedy hare challenged a slow tortoise to a race. The hare raced ahead but stopped to nap. Meanwhile, the tortoise kept moving slowly and steadily, crossing the finish line before the hare woke up. Slow and steady wins the race!
                """,
                """
                Jack and the Beanstalk:
                Jack traded a cow for magic beans. Overnight, a giant beanstalk grew into the clouds. Jack climbed it, found a giant’s castle, and stole gold, a harp, and a goose that laid golden eggs. He chopped the beanstalk down and lived happily ever after.
                """,
                """
                The Boy Who Cried Wolf:
                A shepherd boy shouted “Wolf!” to trick villagers. When a real wolf came, no one believed him. The sheep were eaten, and the boy learned that lying has consequences. Always tell the truth!
                """,
                """
                The Velveteen Rabbit:
                A stuffed rabbit wished to become real. The boy who loved him hugged him every day. When the boy got sick, the rabbit was nearly thrown away—but love had made him real. A fairy turned him into a living rabbit at last.
                """,
                """
                The Gingerbread Man:
                A woman baked a gingerbread man who ran away. "Run, run, as fast as you can! You can’t catch me, I’m the Gingerbread Man!" he shouted. But a clever fox offered help—and then gobbled him up. Be careful who you trust!
                """,
                """
                The Ant and the Grasshopper:
                The ant worked hard gathering food for winter. The grasshopper sang and danced. When snow came, the grasshopper was hungry, but the ant had plenty. The story teaches us to prepare for the future.
                """,
                """
                Corduroy:
                Corduroy was a teddy bear in a store who lost a button. At night, he explored the store to find it. A kind little girl bought him anyway, took him home, and sewed on a button. Now Corduroy had a real friend!
                """,
                """
                Where the Wild Things Are:
                Max misbehaved and was sent to bed. His room turned into a jungle and he sailed to where the Wild Things are. He became their king but missed home. He returned to find his dinner waiting—still warm. Home is where love is.
                """,
                """
                The Rainbow Fish:
                The Rainbow Fish had shiny, beautiful scales but was lonely. When he shared his scales with others, he found happiness and friends. Sharing makes life more colorful!
                """,
                """
                La Llorona (The Weeping Woman):
                A woman lost her children and now roams near rivers at night, crying, "¡Ay, mis hijos!" It's said that if you hear her wails, danger is near. Children are warned not to wander too far from home. Her story teaches respect and fear of the unknown.
                """,
                """
                The Rabbit in the Moon:
                The god Quetzalcoatl was traveling the Earth when he became tired and hungry. A rabbit offered itself as food. Touched by its kindness, Quetzalcoatl raised the rabbit to the moon. Today, you can still see its shape shining from the night sky.
                """,
                """
                The Legend of Popocatépetl and Iztaccíhuatl:
                A warrior and princess fell in love, but she died believing he was lost. Grief-stricken, he carried her to the mountains and stood watch forever. The gods turned them into volcanoes. To this day, Popocatépetl smokes with eternal love.
                """,
                """
                Cinderella:
                Cinderella lived with her cruel stepmother and stepsisters. With help from a fairy godmother, she went to the royal ball. The prince found her glass slipper and searched the land. When it fit her foot, they married and she left her life of sorrow behind.
                """,
                """
                The Ugly Duckling:
                A little duckling was mocked for being different. Everyone called him ugly. Seasons passed, and he grew lonely. One day, he saw his reflection — he was a beautiful swan. He realized he had always been special, just misunderstood.
                """,
                """
                The Bremen Town Musicians:
                A donkey, dog, cat, and rooster, too old to work, set out to become musicians in Bremen. They scared off robbers by standing on each other and making noise. They found a home and lived happily together, proving it's never too late to find joy.
                """,
                """
                Little Red Riding Hood:
                Red Riding Hood went to visit her grandma. A wolf tricked her and took her place. "What big eyes you have!" she said. "All the better to see you!" said the wolf. But a hunter came just in time and saved them. Be cautious of strangers — even in the woods.
                """
        ],
        "Hindi": [
                """
                चतुर खरगोश और शेर:
                एक बार जंगल में एक भयानक शेर रहता था। वह हर दिन एक जानवर को खा जाता। जानवरों ने मिलकर योजना बनाई और चतुर खरगोश को भेजा। खरगोश ने शेर को बताया कि एक और शेर है जो उससे ज़्यादा ताकतवर है। शेर ने गुस्से में आकर पानी में झाँका और अपनी ही परछाई देखकर उस पर हमला कर दिया और डूब गया। सभी जानवर खुश हो गए।
                """,
                """
                बुद्धिमान तोता:
                एक राजा के पास एक बोलने वाला तोता था जो बहुत बुद्धिमान था। एक दिन चोर महल में घुसा, लेकिन तोते ने शोर मचाकर सबको जगा दिया। राजा ने तोते को इनाम दिया और कहा, “तुम सच्चे रक्षक हो!”
                """,
                """
                आलसी किसान:
                एक किसान बहुत आलसी था। उसकी फसल खराब हो जाती थी। एक दिन उसने सपना देखा कि मेहनत करने से उसकी ज़िंदगी बदल सकती है। अगले दिन से वह मेहनत से खेत जोतने लगा, और कुछ ही महीनों में फसल लहलहाने लगी।
                """,
                """
                नीली परी और नन्ही बच्ची:
                रात को सोते वक़्त एक नन्ही बच्ची की ख्वाहिश थी कि एक परी आए और उसे कहानी सुनाए। एक नीली चमकदार परी आई और उसे चांद और तारों की कहानी सुनाई। बच्ची मुस्कुराते हुए गहरी नींद में सो गई।
                """,
                """
                गधा और घोड़ा:
                एक गधा और घोड़ा साथ-साथ चलते थे। गधा थक गया और घोड़े से मदद माँगी, लेकिन घोड़ा अनसुना कर गया। कुछ दूर जाकर गधा गिर पड़ा। अब मालिक ने घोड़े पर ही गधे का बोझ रख दिया। घोड़ा समझ गया कि मदद करना हमेशा अच्छा होता है।
                """,
                """
                चूहा और शेर:
                एक बार की बात है, एक चूहा एक शेर के ऊपर खेल रहा था। शेर ने उसे पकड़ लिया, लेकिन चूहे ने कहा कि एक दिन वह उसकी मदद करेगा। शेर ने हँसते हुए उसे छोड़ दिया। कुछ दिन बाद शेर जाल में फँस गया। चूहा आया और जाल काटकर शेर को आज़ाद किया।
                """,
                """
                झूठा लड़का:
                एक गांव में मोहन नाम का लड़का बहुत झूठ बोलता था। एक दिन उसने 'भेड़िया आया' कहकर सबको डराया। जब सच में भेड़िया आया, तब कोई मदद को नहीं आया। उसे अपने झूठ बोलने का पछतावा हुआ।
                """,
                """
                प्यासा कौवा:
                गर्मी के दिन थे और एक कौवा बहुत प्यासा था। उसे एक घड़ा मिला लेकिन पानी बहुत नीचे था। उसने पास के कंकड़ एक-एक करके डाले और पानी ऊपर आ गया। कौवे ने पानी पिया और उड़ गया।
                """,
                """
                सच्चा दोस्त:
                दो दोस्त जंगल से गुजर रहे थे। एक भालू सामने आ गया। एक दोस्त पेड़ पर चढ़ गया, दूसरा ज़मीन पर लेट गया। भालू गया और चला गया। पहले दोस्त ने पूछा कि भालू ने क्या कहा? दूसरा बोला: 'सच्चे दोस्त कभी अकेला नहीं छोड़ते'।
                """,
                """
                सुनहरी मछली:
                एक गरीब मछुआरे को एक दिन एक सुनहरी मछली मिली। मछली बोली, मुझे छोड़ दो, मैं तुम्हारी मदद करूंगी। मछुआरे ने उसे छोड़ दिया। अगली सुबह उसका घर खाने से भर गया था। उसने कभी लालच नहीं किया और हमेशा खुश रहा।
                """,
                """
                ईमानदार लकड़हारा:
                एक लकड़हारा नदी में कुल्हाड़ी गिरा बैठा। जलपरी ने सोने और चांदी की कुल्हाड़ी दिखाकर पूछा, क्या ये तुम्हारी है? लकड़हारा बोला नहीं। उसकी ईमानदारी से खुश होकर जलपरी ने तीनों कुल्हाड़ियाँ उसे दे दीं।
                """,
                """
                छोटा पौधा:
                एक छोटा पौधा रोज़ सूरज की ओर देखता और बड़ा बनने का सपना देखता। धीरे-धीरे वह बड़ा हुआ, छाया देने लगा और पक्षी उस पर घर बनाने लगे। उसने सीखा कि धैर्य और समय से हर सपना साकार होता है।
                """,
                """
                मिठाई वाला बंदर:
                एक गांव में बंदर था जो हर दिन बच्चों की मिठाइयाँ चुरा लेता। बच्चों ने मिलकर योजना बनाई और नकली मिठाई रख दी। बंदर ने चखते ही मुँह बनाया और फिर कभी चोरी नहीं की।
                """,
                """
                पंख वाला हाथी:
                एक समय की बात है, एक हाथी चाहता था कि उसके भी पंख हों। लेकिन उड़ने की कोशिश में वह बार-बार गिरता। अंत में उसने सीखा कि हर किसी की खूबी अलग होती है, और उसे खुद से प्यार करना चाहिए।
                """,
                """
                चमकता पत्थर:
                एक गरीब लड़के को एक पुराना पत्थर मिला। वह उसे साफ करके बाज़ार में ले गया। वहां एक जौहरी ने उसे असली हीरा बताया। लड़का खुश हुआ लेकिन उसने उसे बेचने के बजाय संग्रहालय को दान कर दिया।
                """,
                """
                बहादुर बिल्ली:
                एक बिल्ली गांव में रहती थी। एक रात चोर आया, बिल्ली ने जोर-जोर से म्याऊँ की, सब जाग गए। चोर पकड़ा गया। गांव वालों ने बिल्ली को दूध से भरा कटोरा इनाम में दिया।
                """,
                """
                दयालु बादल:
                एक बादल को धरती की प्यास देखकर बहुत दुःख हुआ। उसने अपने सारे पानी से बारिश कर दी। खेतों में हरियाली छा गई और गांव वाले खुश हो गए। बादल ने सिखाया कि मदद का असर हमेशा गहरा होता है।
                """,
                """
                उड़ता तकिया:
                एक लड़की को एक जादुई तकिया मिला जो उड़ सकता था। वह रात में चुपचाप उड़ती और गरीब बच्चों के पास जाकर उनके सपनों में कहानियाँ सुनाती। सब बच्चे उसे 'कहानी परी' कहते थे।
                """,
                """
                मेनका और सितारा:
                मेनका को एक चमकता तारा मिला। तारा बोला, एक इच्छा मांगो। उसने कहा, “दूसरों को खुश देखना चाहती हूँ।” तारा मुस्कराया और पूरा गांव हँसी से भर गया। सबसे सुंदर सपना यही था।
                """,
                """
                नींद वाली चिड़िया:
                हर रात एक प्यारी चिड़िया आती और बच्चों के तकिये पर बैठकर गीत गाती। उसकी आवाज़ से सबको मीठी नींद आती। एक दिन वह नहीं आई, तो सब बच्चों ने उसे अपने दिल में बसा लिया।
                """
        ]
    ]
    
    public static let birthdayWishes: [String] = [
        "🎉 Happy Birthday [name]! Hope your day’s full of love, laughs, and cake! 🎂✨",
        
        "🌟 Yo [name], happy freakin’ birthday! Wishing you fun, chill vibes, and good memories. 🎈💫",
        
        "🎊 Big bday hugs, [name]! Hope it’s sweet, sunny, and full of smiles. 🌈🎂",
        
        "🎂 Hey [name], it’s your day! Eat cake, be spoiled, and soak in the love. You deserve it all. ✨",
        
        "🎈 Happy Birthday [name]! You’re a whole vibe—hope today feels just as awesome as you. 💫",
        
        "🎊 [name], it’s party time! May your bday be fun, loud, and legendary. 🥳🌈",
        
        "🌟 Another lap around the sun, [name]! Hope this year’s your best one yet. 🎉✨",
        
        "🎂 [name], cheers to aging like fine wine! 🍷 Stay fabulous and keep killing it. 💫",
        
        "🎊 Happy Birthday, [name]! Keep shining and doing you. The world’s better with you in it. ✨",
        
        "🎉 [name], you’re not older—just cooler! 😎 Have a day full of love, snacks, and surprises. 🎁",
        
        "🌟 [name], wishing you a chill birthday with big laughs and bigger slices of cake! 🎂💫",
        
        "🎊 Hope today brings you the same joy you give everyone else, [name]! You rock. ✨",
        
        "🎂 [name], another year more awesome. Hope your birthday’s got all the good stuff! 🎈",
        
        "🎉 [name], sending good vibes, big hugs, and a whole cake your way! 🧁🌈",
        
        "🌟 [name], it's your day! Keep being amazing. Eat cake and dance a little too! 💃🕺",
        
        "🎊 Happy B-Day [name]! You deserve a day as cool and fun as you are! 🎉",
        
        "🎂 [name], it’s time to relax, get spoiled, and enjoy the heck out of your birthday! 🎁",
        
        "🎉 Hope your birthday’s filled with warm hugs, funny moments, and great food, [name]! 🌈",
        
        "🌟 [name], wishing you a simple, happy, and love-filled birthday. You matter. 💫",
        
        "🎊 Cheers to you, [name]! Another year of being awesome. Let’s celebrate YOU. 🎉"
    ]
}
