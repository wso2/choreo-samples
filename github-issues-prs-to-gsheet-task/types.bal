import ballerinax/github;

type RepoData record {
    string name;
    github:Repository repo;
    github:PullRequest[] prs;
    github:Issue[] issues;
};
