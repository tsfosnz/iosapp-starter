ios_quicknote
=============

A smaller and smarter quick note app - capture what you are looking for and make them interesting

db
======

setting
	setting_id
	name
	value

tag
	tag_id
	name
	name_index

mark
	mark_id
	name
	hint
	level
	icon

image
	image_id
	name
	name_index

category_group

	category_group_id
	name
	
category

	category_id
	category_group_id

	name_index
	name
	level
	order_no
	family

category_tag

	category_id
	tag_id

category_mark
	
	category_id
	mark_id

post
	post_id
	name
	name_index
	description <html editor>

	location
	address
	longitude
	latitude

	watermark

	date
	created
	modified	
	

post_image
	post_id
	image_id

post_tag
	post_id
	tag_id

post_tag
	post_id
	mark_id


		





	
