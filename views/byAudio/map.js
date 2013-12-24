function(doc) {
  if (doc.collection == "audio") {
    emit(doc.collection, doc);
  }
}