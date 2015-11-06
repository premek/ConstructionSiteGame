# ConstructionSiteGame
_Experiment transforming a photo to a game_

I randomly found a [tweet](https://twitter.com/konjak/status/653802433966153728) where someone looked out of his 
window and saw a game level. I thought it would be fun to transform the photo to a (mini)game. 

It was not that easy as I originally thought but I learned 
something interesting about [Depth maps](https://en.wikipedia.org/wiki/Depth_map)

Original photo

<img src="/src/img/bg/bg.jpg?raw=true" width="70%" />

Walls - Defining where the player can step. White = yes, black = no

<img src="/src/img/bg/walls.png?raw=true" width="70%" />

[Depth map](https://en.wikipedia.org/wiki/Depth_map) - Here it is used to add third dimension into the 2D photo. 
It is defining what is in front of the player and what is behind him. 
Closer objects are darker, distant objects are lighter. 
Background (floor) should be gradient from white on top to black on bottom but is ommited here
(same like all white, floor is never in front of the player). 
Windows are implemented but not semi-transparent.

<img src="/src/img/bg/depth.png?raw=true" width="70%" />

In my "game" you can just walk around as a hungry worker and eat fruit :)

## Download
Download from the [releases](https://github.com/premek/ConstructionSiteGame/releases) page.

### Windows executable
- Download **.zip** version
- unpack
- run the **.exe** file

### Linux, Mac OS
- Download **.love** file
- Install LÖVE from your repository or from the [LÖVE website](https://love2d.org/)
- Doubleclick on the .love file or run `love *.love` where *.love is the file you downloaded
