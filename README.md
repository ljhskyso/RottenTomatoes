# Project 1 - RottenTomatoes

Rotten Tomatoes is a movies app displaying box office and top rental DVDs using the [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: 15 hours spent in total

## User Stories

The following **required** functionality is completed:

- [Y] User can view a list of movies. Poster images load asynchronously.
- [Y] User can view movie details by tapping on a cell.
- [Y] User sees loading state while waiting for the API.
- [Y] User sees error message when there is a network error.
- [Y] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [ ] Add a tab bar for Box Office and DVD.
- [ ] Implement segmented control to switch between list view and grid view.
- [Y] Add a search bar.
- [Y] All images fade in.
- [Y] For the large poster, load the low-res image first, switch to high-res when complete.
- [Y] Customize the highlight and selection effect of the cell.
- [Y] Customize the navigation bar.

The following **additional** features are implemented:

- [Y] NavigationBar, StatusBar and MovieDetailsView fades away/in when tapping poster image
- [Y] Implement cancel button in search bar, which resets view when tapped
- [Y] Implement search done feature, which hides keyboard
- [Y] Implement transition animation for cell-image (TransitionFlipFromLeft) and poster-image (TransitionCrossDissolve)
- [Y] Implement transition animation for minize detailView so that it shows title only




## Video Walkthrough 

Here's a walkthrough of implemented user stories:

@dropbox - gif @ https://www.dropbox.com/s/w88ek9m5tb8kdmu/HW1.gif?dl=0'
<img src='https://www.dropbox.com/s/w88ek9m5tb8kdmu/HW1.gif?dl=0' title='Video Walkthrough' width='' alt='Video Walkthrough' />

@dropbox - quicktimes video @ https://www.dropbox.com/s/s2y3he79fgyzo8z/HW1.mov?dl=0

@imgur - gif @ http://i.imgur.com/jbdjItK.gifv
<img src='http://i.imgur.com/jbdjItK.gifv' title='Video Walkthrough' width='' alt='Video Walkthrough' />


GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I found it a bit challenging to set the animation after loading the pics from http.

## License

Copyright [2015] [Jiheng Lu]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.