# Summary:

iOS app for checking and updating progress of Pathfider-like tree skill system. 


# Description:

SKILL SYSTEM consist of core skills (Physique, Intelligence) and secondary skills (Swimming, Acrobatics, Sneaking, Strength, Agility etc.). Any skill may have parent/child relationship with another skill. Core skills are always parents, secondary skills can be both parents and children. Any secondary skill take bonus from parent skill. Developing (adding XP) any skill also automatically develop it parent skill.

Example: developing Swimming will develop it parent - Strength and develop Strength parent - Physique. Bonus from leveling up Physique will be shared by any of its children (Strength, Agility, Toughness etc.).

USER INTERFACE contains large scrollable canvas for drawing skill nodes binded into trees. Mechanism for drawing can draw any number of tree and position them on canvas side by side. 
Tapping a node results in geting info about skill contained. Increase or decrease XP by swiping node up or down, any connected parent skills lose or gain XP in a process. 
Custom side-tab to manage (create\choose\delete) characters.
Supports iphone/ipad.
