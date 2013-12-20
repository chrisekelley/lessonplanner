function(doc) {
  if (doc._attachments) {
    for (var name in doc._attachments) {
      emit(name, name);
    }
  }
}