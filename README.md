# LessonPlanner #

LessonPlanner is a Couchapp that uses [Coconut](https://github.com/chrisekelley/coconut) to create an admin interface for
creating and previewing multimedia lesson plans.

Place the lesson assets in _attachments/lessons:
 - mp3 audio files in _attachments/lessons/audio
 - image files in _attachments/lessons/images

Coconut has been slightly modified to render user interfaces for managing the audio and image assets.
[CKEditor](http://ckeditor.com/) is used for providing a rich text editor for lesson text.

A slightly edited version of the Coconut readme follows:

Coconut renders json defined forms in a browser and then saves the results to couchdb.
=========================================================================================

Instructions
------------

You will need [couchdb](http://couchdb.apache.org/) to make it run:

    apt-get install couchdb

The first time you push the couch, the coconut db will be created for you. You can also create a new database using futon, the handy couchdb GUI by clicking here: [futon on localhost](http://localhost:5984/_utils), or by running this curl command:

    curl -X PUT http://localhost:5984/coconut

To get Coconut working you need to put the files in this directory into a couchdb database. You can accomplish this by using the
[couchapp tool](http://couchapp.org/page/couchapp-python).

    apt-get install couchapp

Now we can use couchapp to push the files into your database:

    couchapp push

Now you can point your browser at the [Coconut](http://localhost:5984/coconut/_design/coconut/index.html)

You may wish to customise the .couchapprc file to point to different targets.

How does this work?
-------------------

CouchDB, [Backbone.js](http://documentcloud.github.com/backbone), [backbone-couchdb](https://github.com/janmonschke/backbone-couchdb), json, fermented eyebrow sweat, fairy dust.


How is this organized?
----------------------

All of the backbone [models](http://documentcloud.github.com/backbone/#Model) and [views](http://documentcloud.github.com/backbone/#Model) have their own file and are in app/models and app/views respectively. app/app.js is responsible for tying it all together.

You can put json forms into the \_docs directory and they will be added to your couch when you do a couchapp push.

How do I render a form?
----------------------

FormView loads the form.template.html, which provides the formElements div, where each form element is appended. FormView's render
function loops through each of the formElements using the addOne function. AddOne sets up the table and inserts new rows when a formelement's closeRow == "true".
It also renders a few other special widgets, such as headers and hidden fields. 
Most form elements are inserted using the following code:
<pre><code>
currentParent.append((new FormElementView({model: formElement})).render().el);
</code>
</pre>
Note how the currentParentName is saved in FormView's currentParentName field - this shows where the element should be appended.

FormElementView renders each element inside a td using the form-element-template, which calls the {{{renderWidget}}} tag.
Handlebars.registerHelper("renderWidget"... in formElementRender.js uses the relevant template based on the inputType for the element. 
Each widget is pre-compiled before the loop:
<pre>
<code>
inputTextWidgetCompiledHtml = Handlebars.compile($("#inputTextWidget").html());
datepickerWidgetCompiledHtml = Handlebars.compile($("#datepickerWidget").html());
checkboxWidgetCompiledHtml = Handlebars.compile($("#checkboxWidget").html());
</code>
</pre>
Look at the index2.html example. Each widget has its own handlebars.js template (see inputTextWidget).  
<pre>
<code>
<script id="dropdownWidget" type="text/x-handlebars-template">
	<select id='{{identifier}}' {{#options}}data-{{name}}='{{value}}' {{/options}} name='{{identifier}}'>
	{{#dropdown enumerations}}
	{{/dropdown}}
	</select>
</script>
</code>
</pre>

Performance test is at http://jsperf.com/test-pre-compiling-handlebars-js-templates

In the current example, the forms are PatientRegistration and ArrestDocket.js.

How do I customise page flow?
-----------------

app.js constructs the Backbone.Router. List the routes in the routes method:
    
    routes: {
        	"home":                 "home",    // #home
        	"newPatient":                 "newPatient",    // #newPatient
        	"arrestDocket":                 "arrestDocket",    // #arrestDocket
            "*actions": "defaultRoute" // matches http://example.com/#anything-here
        }
     
and create a method for each route:
    
        newPatient: function () {
        	registration = new Form({_id: "PatientRegistration"});
        	registration.fetch({
        		success: function(model){
        			(new FormView({model: model})).render(); 
        		}
        	});
        },

           
Other useful info
-----------------

It's a pain to run 'couchapp push' everytime you make a change. Mike wrote a little [watchr](http://rubygems.org/gems/watchr) script that watches for changes to any relevant files and then automatically pushes them into your couch. To get it you need to install rubygems and watchr:

    apt-get install rubygems
    gem install watchr

Help!
----
Check out the project's [issues](https://github.com/vetula/cconut/issues). Please help me fix issues and add any problem that you come across.
