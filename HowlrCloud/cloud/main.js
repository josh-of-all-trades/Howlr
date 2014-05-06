
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("updateLikes", function(request, response) {
	Parse.Cloud.useMasterKey();

	//console.log("TESTING IS HAPPENING!");
	//console.log("this is the id " + request.params.likedUser);

	var query = new Parse.Query(Parse.User);
	query.get(request.params.likedUser, {
		success: function(results){
			//console.log("in the query success");
			//console.log(results);
			results.set("likes", request.params.newLikesArray);
			results.save(null, {
				success: function(saveResults){
					//console.log("in the save success");
					response.success("hurray!");
				},
				error: function(saveError){
					//console.log("qq");
					response.error("booo!");
				}
			});
		},
		error: function(error){
			//console.log("couldn't do it");
			response.error("booo!");
		}
	});
});

Parse.Cloud.define("block", function(request, response){

	Parse.Cloud.useMasterKey();
	var query = new Parse.Query(Parse.User);
	query.get(request.params.blockedUser, {
		success: function(results){
			results.set("blockList", request.params.newBlocksArray);
			results.save(null, {
				success: function(saveResults){
					response.success();
				},
				error: function(saveErr){
					response.error();
				}
			});
		}, 
		error: function(queryError){
			response.error();
		}
	});
});