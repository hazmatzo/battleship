// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

window.App = {
  Models: {},
  Collections: {},
  Views: {},
  Router: {},
  init: function() {
    new App.Router;
    Backbone.history.start();
  }
};

$(document).ready(function() {
  App.init();
});

App.Router = Backbone.Router.extend({
  routes: {
    '': 'show',
  },

  show: function() {
    var myId = currentPlayerId;
    var oppId = otherPlayerId;

    var current_player = new App.Collections.Board();

    current_player.fetch({
     success: function(collection, response, options) {
        var collection_model=collection.at(0);
        var current_player_model=collection_model.get("player");
        var current_opponent_model=collection_model.get("opponent");
        var boardsView = new App.Views.Board();
        boardsView.collection = collection;
        $(document.body).append(boardsView.render());
      }
    });
  }
});

App.Collections.Board = Backbone.Collection.extend({

});

App.Models.Cells = Backbone.Model.extend({

});

App.Models.Board = Backbone.Model.extend({});

App.Collections.Board = Backbone.Collection.extend({
  url: function() {
    return '/players/' + currentPlayerId;
  }
});

App.Views.Board = Backbone.View.extend({
  el: '#app',
  template: 'battleship.mustache',
  initialize: function() {},

  defineClass: function(cell, me) {
    if (!me && cell.hidden) {
      return "hidden";
    } else if (me && cell.hidden && !cell.ship_id) { 
      return "water";
    } else if (me && cell.hidden && !!cell.ship_id) {
      return "ship";
    } else if (!cell.hidden && !!cell.ship_id) {
      return "hit";
    } else if (!cell.hidden && !cell.ship_id) {
      return "miss";
    }
  },

  generateTable: function(type) {
    var that = this;
    var result = [];
    _.each(that.collection.at(0).get(type), function(cell) {
      cell["class"] = that.defineClass(cell, type=="player");
      if (!result[cell.row - 1]) {
        result[cell.row - 1] = {cells: []};
      }
      result[cell.row - 1].cells[cell.column - 1] = cell;
    });

    return result;
  },

  render: function() {
    var that = this;
    $.get('/assets/battleship.mustache', function (data) {
            var player_rows = that.generateTable("player");
            var opponent_rows = that.generateTable("opponent");

            template = Mustache.render(data, {my_rows: player_rows, opponent_rows: opponent_rows });//Option to pass any dynamic values to template
            that.$el.html(template);//adding the template content to the main template.
        }, 'html');
  }
});