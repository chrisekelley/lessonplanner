function(doc) {
  if (doc.formId === "lesson") {
    emit([doc.lastModified], doc);
  }
};
