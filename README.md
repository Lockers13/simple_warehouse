
### Key Design Descisions

I recognised early on that the requirement to have position 0,0 at the bottoim left of the grid was merely a representational issue, rather than a logical one. So I wrote the app from the top-down perspective, then inverted the image of the wh_grid when  drawing it to the console.

Crates were represented using simple lists that held their x, y coordinates
A Hash Map of the form {"product code": [crate1, crate2...]} was use to keep track of the positions of products
A list of lists was used to keep track of all crates 

### Future Potential Improvements

If I had had more time, I would have created and imported a Crate class, with x,y coordinate properties etc., instead of simply using arrays of coordinates to represent crates. This was in actual fact quite messy and led to much avoidable head-scratching.

Secondly, if time had been more on my side, I would have tried to optimize storage space with respect to the placement of crates.