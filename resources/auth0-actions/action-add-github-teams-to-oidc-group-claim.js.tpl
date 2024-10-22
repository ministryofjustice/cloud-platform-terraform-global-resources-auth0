/**
* Handler that will be called during the execution of a PostLogin flow.
*
* @param {Event} event - Details about the user and the context in which they are logging in.
* @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
*/


exports.onExecutePostLogin = async (event, api) => {
  var _ = require('lodash');

  // Apply to 'github' connections only
  if(event.connection.strategy === 'github'){

    // Get user's Github profile and API access key
    const { MGMT_ID, MGMT_SECRET } = event.secrets;
    
    const axios = require("axios");

    const url = 'https://${auth0_tenant_domain}/oauth/token';

      var data = {
          grant_type: 'client_credentials',
          client_id: MGMT_ID,
          client_secret: MGMT_SECRET,
          audience: 'https://${auth0_tenant_domain}/api/v2/',
        };

    try {
      var mgmt_response = await axios.post(url,data)
    } catch (e) {
      console.log(e);
      api.access.deny('Could not post data to management api');
    }

    const headers = {
        'Authorization': 'Bearer '+mgmt_response.data.access_token,
        'content-type': 'application/json'
    };
    const idp_url = 'https://${auth0_tenant_domain}/api/v2/users/'+event.user.user_id

    try {
      var idp_response = await axios.get(idp_url, { headers })
    } catch (e) {
      console.log(e);
      api.access.deny('Could not get idp details');
    }

    var github_identity = _.find(idp_response.data.identities,{ connection: 'github' })
 
    // Get list of user's Github teams
    try {
      var users_response = await axios.get(`https://api.github.com/user/teams?per_page=100`, {
        headers: {
          'Authorization': "token " + github_identity.access_token
        }
      })

      var users_orgs = await axios.get(`https://api.github.com/user/orgs`, {
        headers: {
          'Authorization': "token " + github_identity.access_token
        }
      });
    } catch (e) {
      console.log(e);
      api.access.deny('Could not get users github teams data');
    }

    var teams = users_response.data
    var orgs = users_response.data

    var git_teams = [];
    var git_orgs = []

    _.forEach(teams, function(team, i) { 
        if (team.organization.login === "${moj_github_org}") {
          git_teams.push("github:" + team.slug);
        }
    });

    _.forEach(orgs, function(org) { 
        git_orgs.push(org.login);
    });

    // Add team list to the user's JWT as a custom claim
    api.idToken.setCustomClaim(`${auth0_groupsClaim}`, git_teams);

    api.user.setUserMetadata("gh_teams", git_teams)
    api.user.setUserMetadata("gh_orgs", git_orgs)

    return;

  } else {
    return;
  }
};
