
    // Define a new module. The first argument is what we want to call our app, the second is an array of dependencies (which we don't need at the moment, so there are none)
    angular.module('Rails5App', [])
    .controller('todosController', todosController);

    todosController.$inject = ['$http'];

    function todosController($http){
      var self = this;

      self.all = [];

      function getTodos(){
        $http.get('http://localhost:3000/todos')
          .then(function(response){
            console.log(response);
            self.all = response.data;
          });
      }

      getTodos();
    }
