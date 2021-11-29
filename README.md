# 20211127-SrivalliKanchibotla-NYCSchools

## Features
* The app is compatible with iPhones and iPads in both landscape and portrait modes
* Used NYC schools logo from internet for LaunchScreen, tableHeaderView and DetailVC header
* App has a search bar on the main TableVC to search through the list, filtering by School Names
* The DetailVC has 
  * SAT scores
  * overview of the school
  * School website - opens the school website. Only active when the school has a website
  * School location - can show the location pin in Maps. Only active when the school has location information
  * School contact number - that shows an option to call the number, given the device has a network provider. Only active when the school has contact information.
* Created custom table cells to include a color view on the left side. Since there are no school images, on a long list of schools, this acts as accessibility element

## Instructions to run the app
* The app is built with a deployment target of iOS 13 and above. So it can run on any version of Xcode starting from Xcode 11
* When the app launches, it will fetch the NYC Schools list and corresponding SAT scores. Once that is complete, the tableview reloads.

## Future ideas to improve the app
* Add loading state for the cells instead of text "Loading..."
* Animation for tableview reload
* Peek and pop for cells
* An option to save/favorite a school
* A new tab to display the list of saved/favorite schools
