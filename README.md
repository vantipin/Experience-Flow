# Experience Flow

![Flow](https://cloud.githubusercontent.com/assets/16136204/22787305/e0414fca-eeec-11e6-8d66-c27b7f252ea3.png)

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)]()
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)]()
[![Language](https://img.shields.io/badge/language-objc-green.svg)]()

playerProgressTracker (aka Experience Flow) is an app for checking and updating progress of board RPG. [Pathfider](https://en.wikipedia.org/wiki/Pathfinder_Roleplaying_Game)-like tree skill system. 

- [x] Client-side application
- [x] iCloud sync
- [x] Coredata
- [x] Graphs data visualisation
- [x] Game design experimentation

## Requirements

- iOS Deployment Target 7.0+
- XCode 6.0+

## Demo
![Flow](https://cloud.githubusercontent.com/assets/16136204/22787711/400fcade-eeee-11e6-8875-955edfe16049.gif)

## Installation

If you want to immideately run without iCoud Sync - simply go to projects settings and disable iCloud.
Setup you development team and you should be good to launch it!

## Usage
- Create new character. Choose class, avatar, name.
- Distribute skills point by swiping nodes up to level up the skill and all it's parent skills and down to level down the whole chain down.
- Tap node to get popup explaining rules related to specific skill.
- When character is created, swipe custom sidebar on the left to show it and right to hide it.

### Details
SKILL SYSTEM consist of core skills (Physique, Intelligence) and secondary skills (Swimming, Acrobatics, Sneaking, Strength, Agility etc.). Any skill may have parent/child relationship with another skill. Core skills are always parents, secondary skills can be both parents and children. Any secondary skill take bonus from parent skill. Developing (adding XP) any skill also automatically develop it parent skill.

Example: developing Swimming will develop it parent - Strength and develop Strength parent - Physique. Bonus from leveling up Physique will be shared by any of its children (Strength, Agility, Toughness etc.).

USER INTERFACE contains large scrollable canvas for drawing skill nodes binded into trees. Mechanism for drawing can draw any number of tree and position them on canvas side by side. 
Tapping a node results in geting info about skill contained. Increase or decrease XP by swiping node up or down, any connected parent skills lose or gain XP in a process. 
Custom side-tab to manage (create\choose\delete) characters.
Supports iphone/ipad.

## Project structure
- DataArchiver category. Convert Player data for iCloud sync.
- SkillManager.h Is a singleton class for managing Graphs data.
- SkillTree category responsible for managing Graphs data visualisation.


## License

Experience Flow uses the MIT license. Please file an issue if you have any questions or if you'd like to share how you're using this project.

