---
layout: post
title: Making Flask blueprint templates behave sanely
custom_css: syntax.css
---
A lot of the work I do involves large Flask applications structured in the manner described by the excellent Digital Ocean guide [How To Structure Large Flask Applications](https://www.digitalocean.com/community/tutorials/how-to-structure-large-flask-applications). A side effect of this is that for large applications with many blueprints you end up with a templates folder that is a jumble of subdirectories, each relating to a specific blueprint. On a recent project, I decided I wanted to start storing an individual templates folder inside of
each blueprint's Python module instead of jumbling them all together into a single folder. This would make things more modular, as a single blueprint could be deleted from or added to an application without needing to mess around with another set of templates being copied into the main templates folder.

Luckily (at least I thought at the time), Flask allows you to specify a templates folder when instantiating a Blueprint, as shown:
```python
mod = Blueprint('users', __name__, url_prefix='/users', template_folder="templates")
```
You might hope that this would allow you to create an application structured as shown:
```
app/
  mod_users/
    templates/
      index.html
  mod_camera/
    templates/
      index.html
  templates/
    base.html
```
It seems intuitive that from within the "users" blueprint a call to render_template("index.html") would render the template located in its templates folder which perhaps would extend the base.html template. Unfortunately the reality is not so simple. 

On instantiation of a Flask application with a call to Flask(__name__), Flask creates a [Jinja FileSystemLoader](http://jinja.pocoo.org/docs/dev/api/#jinja2.FileSystemLoader) that points to the root templates folder in the [_PackageBoundObject class](https://github.com/mitsuhiko/flask/blob/33534bb4a9937e6faba5ecec4586519f453369b6/flask/helpers.py#L829-835) (which both a Flask application and a Blueprint inherit from) called jinja_loader, which you would usually access as app.jinja_loader. Makes sense right? Not so fast. 

The FileSystemLoader stored at jinja_loader is not actually the top Jinja loader for a Flask application. In reality, something called a [DispatchingJinjaLoader](https://github.com/mitsuhiko/flask/blob/33534bb4a9937e6faba5ecec4586519f453369b6/flask/templating.py#L46-100) is [created](https://github.com/mitsuhiko/flask/blob/33534bb4a9937e6faba5ecec4586519f453369b6/flask/app.py#L695-706) in the main Flask application. Upon a call to render_template this loader first yields the familiar app.jinja_loader to be used to load a template. If the template is not found there, it then continues to yield the rest of the loaders created for each blueprint that has a template_folder="something" option set:
```python
def _iter_loaders(self, template):
    loader = self.app.jinja_loader
    if loader is not None:
        yield self.app, loader

    for blueprint in self.app.iter_blueprints():
        loader = blueprint.jinja_loader
        if loader is not None:
            yield blueprint, loader
```

This is where the major problem with individual template folders comes in. The end result of this code is that all the individual blueprint template folders are searched sequentially for *any* call to render_template, starting with the base templates folder. In the above example, a call to render_template("index.html") from within the users module could either render its own index.html or that of the camera module depending on which order them come in the blueprints iterator shown above. Aliasing in template names leads to an undefined state where you might get one template or the other depending on what order the directories were searched in. The official Flask [solution](http://flask.pocoo.org/docs/0.10/blueprints/#templates) to this problem is to suggest blueprint folder structure that replicates the global template folder structuring, but split up into modules:
```
app/users/templates/users/index.html
```

This seemed like a silly way of doing things to me when Jinja has totally [workable tools](http://jinja.pocoo.org/docs/dev/api/#jinja2.PrefixLoader) to solve this kind of namespace collision problem. There are two ways to proceed, one of which would be subclassing the Flask Blueprint class and replacing its jinja_loader (a FileSystemLoader pointing to its templates folder) with a PrefixLoader that uses a prefix of the blueprint name. The second solution is to subclass the Flask application class itself and replace the global Jinja loader with something that makes a bit more sense.

I chose to do the second of the two options because it meant my Blueprints could stay totally stock and the only change I would have to make was in my application's __init__ file. I subclassed the Flask application class as shown: 
```python
class MyApp(Flask):
    def __init__(self):
        Flask.__init__(self, __name__)
        self.jinja_loader = jinja2.ChoiceLoader([
            self.jinja_loader,
            jinja2.PrefixLoader({}, delimiter = ".")
        ])
    def create_global_jinja_loader(self):
        return self.jinja_loader

    def register_blueprint(self, bp):
        Flask.register_blueprint(self, bp)
        self.jinja_loader.loaders[1].mapping[bp.name] = bp.jinja_loader
```
There are three important changes being made here. The first is that the jinja_loader object (a FileSystemLoader pointing to the global templates folder) is being replaced with a ChoiceLoader object that will first search the normal FileSystemLoader and then check a PrefixLoader that we create. The second is that the create_global_jinja_loader method is being overridden to simply return the loader we set up in the __init__ method. We will be handling the blueprint's template folders with the PrefixLoader, so there is no need for the [DispatchingJinjaLoader](https://github.com/mitsuhiko/flask/blob/33534bb4a9937e6faba5ecec4586519f453369b6/flask/templating.py#L46-100) to be created. Finally, the register_blueprint method is overridden to add the blueprint's name to the prefix loader's mapping.

The end result is that you can always call render_template('base.html') and Jinja will search the base directory of your site. From within the "users" blueprint, a call to render_template('users.index.html') will always render what you expect it to and a call like render_template('index.html') would fail for being non-specific. If you wanted to, you could even go a step further and subclass Blueprint and create its own render_template method that would first search its own template loader without the need for prefixes. As things stand though, I'm happy with this solution and actually prefer the specificity that the prefix loader provides. 