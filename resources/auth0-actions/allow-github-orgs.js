exports.onExecutePostLogin = async (event, api) => {
  const github_org_allow_list = ["ministryofjustice"];

  if (event.connection.name === "github") {
    const user_orgs = event.user.user_metadata["gh_orgs"];

    const authorized = github_org_allow_list.some(
      (org) => user_orgs.indexOf(org) !== -1,
    );

    if (!authorized) {
      return api.access.deny("Access denied.");
    }
  }
  return;
};
