class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :project
  has_many :hour_records

  scope :with_project,    -> { where("invitation_accepted_at IS NOT NULL AND project_id IS NOT NULL") }
  scope :without_project, -> { where("invitation_accepted_at IS NOT NULL AND project_id IS NULL") }
  scope :confirmed,       -> { where("invitation_sent_at IS NOT NULL AND invitation_accepted_at IS NOT NULL") }
  scope :unconfirmed,     -> { where("invitation_sent_at IS NOT NULL AND invitation_accepted_at IS NULL") }
  scope :collaborators,   -> { where(position: "collaborator") }

  MAJORS = {
    "0" => "Licenciatura en Ciencias Empresariales",
    "1" => "Licenciatura en Matemáticas Aplicadas",
    "2" => "Licenciatura en Física Aplicada",
    "3" => "Ingeniería Mecatrónica",
    "4" => "Ingeniería Industrial",
    "5" => "Ingeniería en Diseño",
    "6" => "Ingeniería Mecánica Automotriz",
    "7" => "Ingeniería en Computación",
    "8" => "Ingeniería en Electrónica",
    "9" => "Ingeniería en Alimentos",
  }

  POSITIONS = {
    "president"       => "Presidente",
    "vicepresident"   => "Vice presidente",
    "coach"           => "Consejero",
    "human_resources" => "Recursos Humanos",
    "system_manager"  => "Administrador de sistema",
    "project_leader"  => "Líder de Proyecto",
    "collaborator"    => "Colaborador",
  }

  def admin?
    %w[president vicepresident coach human_resources system_manager].include? position
  end

  def leader?
    position == "project_leader"
    # Project.exists?(manager_id: id)
  end

  def my_leader
    return [] if admin? or leader? or position.nil?
    Project.where(project_id: project_id, position: "project_leader")
  end

  def full_name
    [fname, lname1, lname2] * " "
  end

  def lname
    [lname1, lname2] * " "
  end

  def position_title
    POSITIONS[position]
  end

  def major_title
    MAJORS[major]
  end

  def activities
    Activity.where(project_id: [project_id, nil])
  end

  def grouped_activities
    grouped_activities = {}
    for_all_users = Activity.where(project_id: nil).to_a.map{|a| [ a.name, a.id ] }
    by_project = Activity.where(project_id: project_id).to_a.map{|a| [ a.name, a.id ] }
    grouped_activities["Actividades generales"] = for_all_users if for_all_users.any?
    grouped_activities["Actividades del proyecto"] = by_project if by_project.any?
    grouped_activities
  end
end
