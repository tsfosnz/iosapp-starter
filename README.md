iOS app backbone
================

Architecture of a Social Network App

Many social network app will require the same functionality on it, and it will have similar architecture :

	The authentication is from server
	The Data is from sever API
	The main functionality is to retrieve data and display them
	The other functionality is to enter and save info on server

Basically all these kind of app will have similar functionality and architecture :

<h3>Authentication module</h3> 

you will have to create the authentication module for current user, the user type could be guest, logged-in, commonly the guest will be able to view those public pages and data, and for registered user who is logged in the app, he will have full functionality of their own.

Basically, the app will deal with two situation of the logged in user, when the user first time logged in the app, it will have to authenticate the user with API, and then save its credential to local storage, thus, the next time, app start, user don’t have to login again.

This process could be complex, as many apps today added Social Network API to access FB, Twitter, Google+ or even more, and the workflow will depend on these SDK too.

<h3>Model + Network</h3>
	
After the user logged in, they will be able to view all data, and this time, the app will have to fetch the data and for later use, they will save these data in local storage, think about an app for example, like twitter, and for each tweet, it will have 1000 bytes, and if the user have more than 10million tweets, and that will have 1,000,000 * 1000 = 10,000 MB data in total.

How could he view all these data in the app? Is it possible? None of the local storage today can save that large data, so the local data cache will save part of the data, probably the latest pages.

Suppose we have 100 tweet as one page for each time, and we will have many pages, we will have a data window to save all these pages into local storage, and then we can fetch them quickly from it, don’t have to access the network again…

The better way, at first we will fetch a small amount of tweets, and then we can fetch them at back-ground as large amount, so we don’t have to fetch them from networking, coz we already save them in local storage…

Commonly in the app, we fetch an small amount of data firstly, and then we will add data to it as the user reading the page to page, that sounds very good, but when user reading through 1 to 1000 page, it will be a lot data in memory too, that’s obviously not the perfect way…

To display the data in the memory, we also need the same data window to control how many pages we should display in current page, and all these data in local storage or in network, and same time, there is a background task to evaluate the window, and do fetch the latest data into the system same time…

That’s just the normal way to design the model and network.

To think about Model, we commonly put Model and network together in the same class, well it looks fine, but when there are many networking functions in the same model, we will feel that’s kind noise with bad readable class definition…

I think the better way is to define Model with its Interface like this way : 


Model

	property A
	property B
	
Model Networking (Category)

	method A
	method B

Model Database (Category)

	method A
	method B

<h3>Cache (Disk + Memory)</h3>

Frankly speaking , iOS device is very quick to load image from Disk, so memory cache almost not necessary, well maybe somebody want to keep the image in the memory, but I wouldn’t…

Cache is to accelerate the app, from networking or local storage, anyway…iOS is good…

Cache should be as simple as possible, not to be a complex one…

The cache will be managed in local db I think, coz we can’t save all images from time to time in the device, that will consume the device storage a lot after a long running. So we will replace those resource as they are out of date, to replace the resource could be a complicated thing, generally cache replacement algorithm will have many kind of type, the simplest one is just replace them from being not updated. 

To think about the cache is a circling queue, and all items in the queue has its timestamp, and we will replace the item based on it, and sort the queue by that too…

Also knowing the cache size and controlling the number of resources is also required. If there are too many small pieces of files in the disk, well obviously it will slow down the app, or even the system, to think about there are 1,000,000 files in the same folder, and when system to build the share mapping to it, it will occupy a lot memory.


<h3>Render engine (Image + Text)</h3>

The render engine, sometimes is critical, for those text, we don’t really worried about, usually it’s not a large block of data and won’t occupy a lot memory, but image is quite different!!

Does iOS device can handle all kind size of image? That’s impossible, they may be able to handle really large image much better than Android, but they can’t support all sizes of cause.

To render an image in the View, we will consider the size of the image, especially there are many images loaded into the app one by one, even the List will release those unused cell, but can we totally rely on them? When they will release those cells, immediately when it’s invisible or ?

I don’t know. To split the large image into pieces is the only way to play with large images, this process could be done in local app or in remote server, to do this in native app, will consume a lot resource, of cause CPU and Memory.

And another way, is to open the file by streaming mode, on this mode, we can obtain pieces of the image, and render parts of them into the View, also this time, we can’t use one View for one image too, could be many Views..

Let’s think about it, the device will be able to support the size of the image as same as screen, I think all device can do that, and if and only if when user read the content, they only can view the image in the screen size, so display the image visible part, will not break the memory forever.

Image
	Cell A
	Cell B
	Cell C

From the size of the image, we will get how many pieces we will need from this Image, for example, if we have a size height limit about 1280pix, and we have image about 2560pix, so we will get two pieces of image, and display them into two cells…

To organize Cells into this situation, is not easy to do, as the List will treat cell as the whole complete one unit to release and re-render.


<h3>Tweet engine (Cache + Sync)</h3>	

We may think about tweet very little, but we should know that the network is not always available, so save the tweet into the cache or local storage, and then sync to the server, will be the basic way to do it.

<h3>Server Performance</h3>

App will consume the resource from server, but we almost can’t calculate it precisely, if we can calculate the consumption of each app, we will have all those useful information to design and boost the server performance.

Today, when you have tweeted something, and then you just want let all these people as your follower to get the information as quick as possible, so how quick it will be, and how slow you can endure?

Like the mainly way to know your tweet have been read by someone else, is that they are re-tweeted it, or they reply to you as well, well you actually don’t know how the app & server works, so you may wait for 3s, or even 1h, whatever it does, just the service should keep their pace up with your patience. 
