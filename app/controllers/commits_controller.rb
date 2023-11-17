class CommitsController < ApplicationController
  def show
    owner = params[:owner]
    repository = params[:repository]
    commit_sha = params[:commit_sha]

    client = Octokit::Client.new
    commit = client.commit("#{owner}/#{repository}", commit_sha)
    
    parent_commit_sha = commit.parents.first&.sha

    author = commit.commit.author.name
    message = commit.commit.message
    files = commit.files.collect{|f| [f.filename, (f.patch.nil? ? [] : f.patch.split("\n"))]}
    commit_time = commit.commit.author.date

    render json: { owner: owner, repository: repository, commit_sha: commit_sha, author: author, message: message, files: files, commit_time: commit_time, parent_commit_sha: parent_commit_sha }
  end
end
