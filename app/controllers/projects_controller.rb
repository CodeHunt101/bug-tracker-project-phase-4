class ProjectsController < ApplicationController
  # Only users that are Admin or Project Manager are able to see the new project view.
  def new
    if current_user.role_name != "Admin" && current_user.role_name != "Project Manager"
      redirect_to user_path(current_user)
    else
      @project = Project.new(project_manager: current_user)
      @lead_developers = User.lead_developers
    end
  end

  def create
    # If user tries to modify its id in the inspect tool they'll see an error message, otherwise project will be created
    if params[:project][:project_manager_id] == current_user.id.to_s
      project = Project.create(project_params)
      redirect_to user_project_path(current_user, project)
    else
      flash[:message] = "Logged user id doesn't match the id of the user submitting the form, please try again."
      @project = Project.new(project_manager: current_user)
      @lead_developers = User.lead_developers
      if project_params
        @prev_params_title = project_params[:title]
        @prev_params_description = project_params[:description]
        @prev_params_lead_developer = project_params[:lead_developer]
      else
        @prev_params_title = ""
      end
      render 'new'
    end
    
  end

  def index
    # If current user is an Admin, user can navigate without restrictions, but if it's not, then the user id must match the user_id route.

    if current_user.role_name == "Admin" ||
      (current_user.id == params[:user_id].to_i && current_user.role_name != "Admin")
      
      user = User.find_by(id: params[:user_id])
      @projects = !user.sent_projects.blank? && user.sent_projects || 
      !user.received_projects.blank? && user.received_projects ||
      user.related_projects
    else
      redirect_to user_path(current_user)
    end
  
  end

  def show
    # If user is an Admin, they can see all projects 
    # If user is a Project manager, Lead Dev or Dev, they'll be able to see only their projects.
    if current_user.role_name == "Admin" ||
      (current_user.role_name == "Project Manager" && current_user.sent_projects.any?{|p| p.id == params[:id].to_i}) ||
      (current_user.role_name == "Lead Developer" && current_user.received_projects.any?{|p| p.id == params[:id].to_i}) ||
      (current_user.role_name == "Developer" && current_user.related_projects.any?{|p| p.id == params[:id].to_i})
        @project = Project.find(params[:id])
        @project_developers = @project.developers_uniq
        @project_tickets = @project.tickets
        @project_ticket_assignments = @project.ticket_assignments
    else
      redirect_to user_path(current_user)
    end
    
  end

  def edit
    # If user isn't an Admin and tries to see other users projects, they redirect to user's profile
    if current_user.role_name != "Admin" && current_user.id != params[:user_id].to_i
      redirect_to user_path(current_user)
    else
    # If user is a Project manager or Lead Dev, they'll be able to see only their projects.
      if (current_user.role_name == "Project Manager" && current_user.sent_projects.any?{|p| p.id == params[:id].to_i}) ||
        (current_user.role_name == "Lead Developer" && current_user.received_projects.any?{|p| p.id == params[:id].to_i})
        @project = Project.find(params[:id])
        @lead_developers = User.lead_developers
      else
        redirect_to user_path(current_user)
      end
    end    
  end

  def update
  # If user tries to modify its id in the inspect tool they'll see an error message, otherwise project will be updated
    if params[:project][:project_manager_id].to_i == current_user.id
      project = Project.find(params[:id])
      project.update(project_params)
      redirect_to user_project_path(current_user, project)
    else
      flash[:message] = "Logged user id doesn't match the id of the user submitting the form, please try again."
      @project = Project.new(project_manager: current_user)
      @lead_developers = User.lead_developers
      if project_params
        @prev_params_title = project_params[:title]
        @prev_params_description = project_params[:description]
        @prev_params_lead_developer = project_params[:lead_developer]
      else
        @prev_params_title = ""
      end
      render 'new'
    end
  end
  
  private
  
  def project_params
    params.require(:project).permit(
      :title,
      :description,
      :project_manager_id,
      :lead_developer_id,
    )
  end
end