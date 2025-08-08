import Foundation


struct Story: Identifiable, Codable {
    let id: Int
    let name: String
    let thumbnailImageName: String
    let transcript: String // This will now be a short description
    let storyViewName: String
    
    // Computed property to get the full story content
    var fullStoryContent: String {
        switch storyViewName {
        case "BraveLittleRabbitView":
            return """
The Brave Little Rabbit
Finding Courage in the Forest

Once upon a time, in a lush green forest, lived a little rabbit named Thumper. Unlike other rabbits who were quick and confident, Thumper was small and often afraid. He would hide behind bushes when he heard loud noises and trembled at the sight of shadows.

Thumper's Challenges:
• He was afraid of the dark forest paths
• Loud sounds made him jump and hide
• Other animals seemed so much braver
• He wanted to explore but was too scared

One day, Thumper heard a tiny voice crying for help. It was a baby bird that had fallen from its nest. The other animals were too busy to notice, but Thumper could see the little bird clearly.

His heart was pounding, but something inside him told him he had to help. Taking a deep breath, Thumper hopped toward the baby bird, trying to ignore his trembling legs.

"Even though I'm scared, I can still be brave," Thumper whispered to himself as he carefully picked up the baby bird and carried it to safety.

From that day on, Thumper learned that being brave doesn't mean never being afraid. It means doing what's right even when you're scared. The other animals began to see Thumper differently, and he started to see himself differently too.

He still felt afraid sometimes, but now he knew that courage was a choice he could make every day. The little rabbit who was once so timid became known as the brave little rabbit who helped others find their courage too.
"""
            
        case "BearFamilyHibernationView":
            return """
The Bear Family's Hibernation
Preparing for Winter Together

In a dense forest filled with tall pines, lived Papa Bear, Mama Bear, and Baby Bear. Their den was a warm cave, perfect for their winter hibernation. As autumn leaves fell, they began preparing for their long sleep, knowing winter was near. They needed food to last and a cozy den to keep them warm.

What each bear did:
• Papa Bear roamed the forest, collecting sweet berries and catching fish from the stream.
• Mama Bear gathered soft leaves and moss, lining the den to make it snug.
• Baby Bear, eager to help, scampered around, finding small nuts and seeds to store.

"Even when Papa Bear got a thorn in his paw or Mama Bear struggled with heavy branches, they helped each other, laughing and learning."

As the first snowflakes fell, the bears finished their preparations. They checked their food piles—berries, fish, nuts, and seeds—and fluffed the moss in their den.

That night, they snuggled close, sharing one last story about a brave bear who saved his family. As they drifted off, the wind howled outside, but their den was warm and safe. The bears slept soundly, dreaming of spring, knowing their love and teamwork would carry them through winter.
"""
            
        case "DragonCouldntBreatheFireView":
            return """
The Dragon Who Couldn't Breathe Fire
A Tale of Hidden Talents

High up in the misty mountains, lived a young dragon named Spark. Unlike other dragons who could breathe magnificent flames, Spark could only produce tiny puffs of smoke. The other dragons would laugh and say, "What kind of dragon are you if you can't breathe fire?"

Spark's Struggles:
• He tried to breathe fire but only coughed smoke
• Other dragons made fun of his small puffs
• He felt like he wasn't a real dragon
• He wanted to be like the others so badly

One day, a terrible storm hit the mountain. The wind was so strong that it blew out all the fires in the dragon caves. The dragons were cold and miserable, and they couldn't cook their food or keep warm.

Spark watched as the other dragons tried to relight their fires, but the wind kept blowing them out. Then he had an idea! His tiny puffs of smoke might be small, but they were gentle and steady.

"Maybe my small puffs can help in a different way," Spark thought as he carefully blew his gentle smoke onto the embers, slowly bringing the fires back to life.

The other dragons were amazed! Spark's gentle puffs were perfect for carefully tending fires without burning them out. Soon, all the dragon caves were warm and cozy again, and the dragons realized that Spark had a special talent all along.

From that day on, Spark became known as the dragon who could tend fires better than anyone else. He learned that being different doesn't mean being less—it means having unique gifts that others might need.
"""
            
        case "DreamOfFlyingView":
            return """
The Dream of Flying
Soaring Through Imagination

In a cozy bedroom, little Emma lay in her bed, staring at the stars through her window. She had always dreamed of flying like the birds she watched from her window. Every night, she would close her eyes and imagine herself soaring through the clouds.

Emma's Dreams:
• She wanted to fly like the birds in the sky
• She imagined touching the fluffy white clouds
• She dreamed of seeing the world from above
• She wished she could visit the moon and stars

One night, as Emma was falling asleep, she felt something magical happening. Her bed began to gently lift off the ground, and she found herself floating toward the ceiling. Her heart was filled with joy as she realized her dream was coming true.

"Look at me, I'm really flying!" Emma whispered with excitement as she floated around her room, touching the ceiling and dancing with the shadows.

Emma flew out her window and into the night sky. She soared past the treetops, danced with the clouds, and even visited the moon. The stars twinkled hello, and the wind carried her gently through the sky.

When morning came, Emma found herself back in her bed, but she knew it wasn't just a dream. She had learned that imagination could take her anywhere she wanted to go. From that day on, whenever Emma closed her eyes, she could fly anywhere her heart desired.
"""
            
        case "ForestFriendsStormView":
            return """
The Forest Friends and the Storm
Working Together in Hard Times

In a peaceful forest, all the animals lived happily together. There was wise old Owl, quick Squirrel, gentle Deer, and brave Fox. They shared the forest and helped each other when needed.

The animals' peaceful life:
• They played together in the sunny meadows
• They shared food and stories under the trees
• They looked out for each other's safety
• They were like one big forest family

One day, dark clouds gathered overhead, and a terrible storm began to rage. The wind howled, the rain poured, and lightning flashed across the sky. The animals were scared and didn't know what to do.

Owl called everyone to the big oak tree, which had the strongest branches. "We need to work together to stay safe," he hooted wisely.

Squirrel gathered nuts and berries for everyone to eat. Deer helped the smaller animals find shelter under the thickest bushes. Fox kept watch for any danger, while Owl made sure everyone was accounted for.

"Together we are stronger than any storm," the animals said as they huddled close, sharing warmth and courage.

When the storm finally passed, the animals discovered that working together had made them even better friends. They learned that friendship and teamwork could help them overcome any challenge, no matter how scary it seemed.
"""
            
        case "LostKittenJourneyView":
            return """
The Lost Kitten's Journey Home
Finding Help in Unexpected Places

Little Whiskers was a curious kitten who loved to explore. One day, while chasing a butterfly, she wandered too far from home and found herself in a big, unfamiliar city. The buildings were tall, the streets were busy, and Whiskers was very scared.

Whiskers' challenges in the city:
• She didn't know which way was home
• The loud noises frightened her
• She was hungry and tired
• She missed her family terribly

As Whiskers sat on a street corner, feeling lost and alone, a kind pigeon landed beside her. "You look lost, little one," the pigeon cooed gently. "Let me help you find your way home."

The pigeon flew high above the city and spotted Whiskers' neighborhood. He guided her through the busy streets, avoiding the noisy cars and scary dogs. Along the way, they met other helpful animals—a friendly mouse who shared some cheese, and a wise old cat who gave them directions.

"Sometimes the best help comes from the most unexpected friends," Whiskers learned as she followed her new friends through the city.

Finally, after a long journey, Whiskers saw her familiar house and her worried family waiting on the porch. She ran into their arms, purring with joy. From that day on, Whiskers learned that even when you're lost, there are always kind hearts ready to help you find your way home.
"""
            
        case "MermaidOceanLessonView":
            return """
The Mermaid's Ocean Lesson
Protecting Our Beautiful Seas

Deep in the crystal blue ocean, lived a young mermaid named Coral. She loved exploring the underwater world with all its colorful fish, swaying seaweed, and mysterious shipwrecks. But one day, Coral noticed something that made her very sad.

What Coral discovered:
• Plastic bottles floating in the water
• Fish getting tangled in old fishing nets
• Coral reefs losing their bright colors
• Sea creatures looking sick and sad

Coral swam to the wise old sea turtle, who had lived in the ocean for many years. "What's happening to our beautiful ocean?" Coral asked with tears in her eyes.

The sea turtle explained that humans sometimes forget to take care of the ocean. "But we can help teach them," he said gently. "Every little bit of help makes a difference."

Coral decided to become an ocean protector. She gathered her fish friends and together they cleaned up the plastic, freed trapped sea creatures, and planted new seaweed gardens. They even made signs out of shells to remind humans to keep the ocean clean.

"Every creature in the ocean is part of our family," Coral told her friends. "We must protect our home together."

Soon, the ocean began to heal. The fish were happier, the coral reefs grew brighter, and even the humans started to notice the difference. Coral learned that even a little mermaid could make a big difference when she cared enough to help.
"""
            
        case "SecretGardenDiscoveryView":
            return """
The Secret Garden Discovery
The Magic of Growing Things

Behind an old stone wall, hidden from the busy world, lay a forgotten garden. No one had tended it for years, and the plants were sad and droopy. But one day, three curious children—Emma, Jake, and Lily—discovered the rusty gate and decided to explore.

What the children found:
• Overgrown bushes and tangled vines
• A broken birdbath and rusty tools
• Seeds scattered on the ground
• A tiny sprout trying to grow

The children looked at each other with excitement. "We can bring this garden back to life!" Emma said. They rolled up their sleeves and got to work, pulling weeds, clearing paths, and planting new seeds.

They learned about different plants—how some needed lots of sun, others preferred shade, and how water and love made everything grow. They discovered that gardening was like magic, where tiny seeds could become beautiful flowers and delicious vegetables.

"Every plant has its own story," Jake said as they watched their garden grow. "And we get to be part of that story."

As the weeks passed, the secret garden transformed. Bright flowers bloomed, butterflies danced in the air, and birds came to sing. The children had created a magical place where nature and friendship grew together.

The garden became their special place, where they could dream, play, and watch the magic of growing things. They learned that with patience, care, and a little bit of magic, they could make the world more beautiful.
"""
            
        case "ToysNighttimeAdventureView":
            return """
The Toys' Nighttime Adventure
When Playtime Never Ends

In a cozy bedroom, when the children were fast asleep, something magical happened. The toys began to wake up and come to life! Teddy Bear stretched his fluffy arms, Doll opened her bright eyes, and Toy Car's wheels started to spin with excitement.

The toys' secret life:
• They came alive when children slept
• They had their own adventures and games
• They explored the house together
• They protected each other like a family

Tonight was a special night—it was the night of the Great Toy Parade. All the toys from the bedroom gathered together, including the brave Action Figures, the graceful Ballerina Doll, and the wise Old Robot.

They marched through the house, visiting the kitchen where the pots and pans joined their parade, and the living room where the cushions became their royal thrones. They even discovered a secret passage behind the bookshelf that led to a magical toy kingdom.

"Every night is an adventure when you're a toy," Teddy Bear said as they explored new corners of their world.

As the first light of dawn appeared, the toys knew it was time to return to their places. They hurried back to the bedroom, taking their positions just as the children began to stir.

The children never knew about their toys' secret adventures, but they always wondered why their toys seemed to smile a little brighter each morning. The toys knew that their nighttime adventures made them even better friends and playmates.
"""
            
        case "YoungWizardLessonView":
            return """
The Young Wizard's Lesson
The Most Powerful Magic of All

In a mystical tower high in the mountains, lived a young wizard named Zara. She was learning to cast spells and brew potions, but her magic wasn't working as well as the other young wizards. Zara felt discouraged and wondered if she would ever be a great wizard.

Zara's magical struggles:
• Her spells often fizzled instead of sparkled
• Her potions sometimes turned the wrong colors
• The other wizards seemed more powerful
• She wanted to help others but felt inadequate

One day, Zara was practicing her spells when she heard a cry for help from the village below. A little girl had lost her beloved pet rabbit, and she was heartbroken. Zara knew she had to help, even if her magic wasn't perfect.

She flew down to the village on her broomstick and found the little girl crying. Instead of using a fancy spell, Zara simply sat with the girl, listened to her story, and helped her search for the rabbit. They looked under bushes, behind trees, and finally found the rabbit safe and sound.

"The most powerful magic isn't in spells or potions," Zara realized. "It's in kindness and helping others."

From that day on, Zara became known as the wizard who could heal hearts and bring smiles. She learned that the greatest magic came from caring about others and using her gifts to help those in need. The other wizards soon realized that Zara's kind heart was the most powerful magic of all.
"""
            
        default:
            return transcript
        }
    }
    
    static let allStories: [Story] = [
        Story(
            id: 0,
            name: "The Brave Little Rabbit",
            thumbnailImageName: "brave_rabbit",
            transcript: "A little rabbit learns to be brave when his friends need help.",
            storyViewName: "BraveLittleRabbitView"
        ),
        Story(
            id: 1,
            name: "The Bear Family's Hibernation",
            thumbnailImageName: "bear_family",
            transcript: "A bear family prepares for winter together, teaching about teamwork and preparation.",
            storyViewName: "BearFamilyHibernationView"
        ),
        Story(
            id: 2,
            name: "The Dragon Who Couldn't Breathe Fire",
            thumbnailImageName: "dragon_fire",
            transcript: "A young dragon discovers his unique talents when others need his help.",
            storyViewName: "DragonCouldntBreatheFireView"
        ),
        Story(
            id: 3,
            name: "The Dream of Flying",
            thumbnailImageName: "dream_of_flying",
            transcript: "A child's dream of flying becomes real through the power of imagination.",
            storyViewName: "DreamOfFlyingView"
        ),
        Story(
            id: 4,
            name: "The Forest Friends and the Storm",
            thumbnailImageName: "forest_friends",
            transcript: "Forest animals work together to stay safe during a terrible storm.",
            storyViewName: "ForestFriendsStormView"
        ),
        Story(
            id: 5,
            name: "The Lost Kitten's Journey Home",
            thumbnailImageName: "lost_kitten",
            transcript: "A lost kitten finds her way home with the help of kind animal friends.",
            storyViewName: "LostKittenJourneyView"
        ),
        Story(
            id: 6,
            name: "The Mermaid's Ocean Lesson",
            thumbnailImageName: "mermaids_ocean",
            transcript: "A young mermaid learns about protecting the ocean and helping sea creatures.",
            storyViewName: "MermaidOceanLessonView"
        ),
        Story(
            id: 7,
            name: "The Secret Garden Discovery",
            thumbnailImageName: "secret_garden",
            transcript: "Children discover and restore a forgotten garden, learning about nature and friendship.",
            storyViewName: "SecretGardenDiscoveryView"
        ),
        Story(
            id: 8,
            name: "The Toys' Nighttime Adventure",
            thumbnailImageName: "toy_nighttime",
            transcript: "Toys come to life at night and have magical adventures when children are asleep.",
            storyViewName: "ToysNighttimeAdventureView"
        ),
        Story(
            id: 9,
            name: "The Young Wizard's Lesson",
            thumbnailImageName: "young_wizards",
            transcript: "A young wizard learns that kindness and helping others is the most powerful magic.",
            storyViewName: "YoungWizardLessonView"
        )
    ]
}
