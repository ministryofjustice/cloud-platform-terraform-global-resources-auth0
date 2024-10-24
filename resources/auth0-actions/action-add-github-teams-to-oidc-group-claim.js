exports.onExecutePostLogin = async (event, api) => {
  const axios = require("axios");

  const {
    MGMT_ID,
    MGMT_SECRET,
    AUTH0_TENANT_DOMAIN,
    AUTH0_GROUPS_CLAIM,
    MOJ_ORG,
  } = event.secrets;

  let userOrgs;
  let userTeams;
  if (event.connection.strategy === "github") {
    const url = `https://${AUTH0_TENANT_DOMAIN}/oauth/token`;

    var data = {
      grant_type: "client_credentials",
      client_id: MGMT_ID,
      client_secret: MGMT_SECRET,
      audience: `https://${AUTH0_TENANT_DOMAIN}/api/v2/`,
    };

    try {
      const mgmt_response = await axios.post(url, data);
      const headers = {
        Authorization: "Bearer " + mgmt_response.data.access_token,
        "content-type": "application/json",
      };

      const idp_url =
        `https://${AUTH0_TENANT_DOMAIN}/api/v2/users/` + event.user.user_id;

      const idpResponse = await axios.get(idp_url, { headers });

      const githubId = idpResponse.data.identities.find(
        (id) => id.connection === "github",
      );

      const githubHeaders = {
        headers: {
          Authorization: "token " + githubId.access_token,
        },
      };

      userOrgs = await axios.get(`https://api.github.com/user/orgs`, {
        ...githubHeaders,
      });

      const authorized = userOrgs.data.some((org) => org.login === MOJ_ORG);

      if (!authorized) {
        return api.access.deny("Access denied.");
      }

      userTeams = await axios.get(
        `https://api.github.com/user/teams?per_page=100`,
        { ...githubHeaders },
      );
    } catch (e) {
      api.access.deny(
        "Could not return valid result from the management api and github",
      );
    }

    const mojTeams = userTeams.data
      .filter((t) => (t.organization.login === MOJ_ORG ? true : false))
      .map((t) => `github:${t.slug}`);

    // Add team list to the user's JWT as a custom claim
    api.idToken.setCustomClaim(`${AUTH0_GROUPS_CLAIM}`, mojTeams);

    api.user.setUserMetadata("gh_teams", mojTeams);

    return;
  } else {
    return;
  }
};
