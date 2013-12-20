var AssetCollection = Backbone.Collection.extend({
  model: Asset,
  db : {
    keys: null
  },
  parse: function(response) {
    //console.log("parse:" + JSON.stringify(response));
    //return response;
    return _.pluck(response, 'key');
  },
  initialize: function(){
  }
});
