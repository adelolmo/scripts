// https://gist.github.com/mayo/6d4ef8397948f77ffdea
var fs = require('fs');

var source = process.argv[2];
var destDir = process.argv[3];

var notes = require(source);

notes.forEach(function(note) {
  var content = note.content.trim();
  var filename = null;
  var created = note.createdate;
  var modified = note.modifydate;

  var title = content.match(/(.*)\n+/)[1];

  if (title) {
    content = "# " + title.trim() + "\n\n" + content.substr(title.length).trim();
    filename = title.trim();

  } else {
    console.log(note);
    console.log(data);
    throw new Error("can't figure out note");
  }

  //sanitize filename
  filename = filename.replace(/([^\w-_\(\) '+=])/g, '');

  //keep filename length sane
  if (filename.length > 60) {
    var sentencePos = filename.indexOf(".");
    if (sentencePos > 0) filename = filename.substr(0, sentencePos);

    if (filename.length > 60) {
      spacePos = filename.indexOf(" ", 60);
      if (spacePos > 0) filename = filename.substr(0, filename.indexOf(" ", 60));
    }
  }

  //append .note to filename
  filename += ".md"

  if (note.tags || note.key) {
    content += "\n\n";

    if (note.tags) content += "TAGS: " + note.tags.join(", ") + "\n";
    if (note.key) content += "KEY: " + note.key + "\n";
  }

  fs.writeFileSync(destDir + "/" + filename, content);
});
