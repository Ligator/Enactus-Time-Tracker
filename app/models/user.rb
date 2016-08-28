class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :project

  scope :with_project,    -> { where("invitation_accepted_at IS NOT NULL AND project_id IS NOT NULL") }
  scope :without_project, -> { where("invitation_accepted_at IS NOT NULL AND project_id IS NULL") }
  scope :confirmed,       -> { where("invitation_sent_at IS NOT NULL AND invitation_accepted_at IS NOT NULL") }
  scope :unconfirmed,     -> { where("invitation_sent_at IS NOT NULL AND invitation_accepted_at IS NULL") }

  MAJORS = {
    0 => "Ingeniería Mecatrónica",
    1 => "Ingeniería en Alimentos",
    2 => "Licenciatura en Ciencias Empresariales",
    3 => "Licenciatura en Matemáticas Aplicadas",
    4 => "Ingeniería Industrial",
    5 => "Ingeniería en Diseño",
    6 => "Ingeniería Mecánica Automotriz",
    7 => "Ingeniería en Computación",
    8 => "Ingeniería en Electrónica",
  }

  POSITIONS = {
    "president"       => "Presidente",
    "vicepresident"   => "Vice presidente",
    "coach"           => "Consejero",
    "human_resources" => "Recursos Humanos",
    "system_manager"  => "Administrador de sistema",
    "project_leader"  => "Líder de Proyecto",
    "colaborator"     => "Colaborador",
  }

  def admin?
    %w[president vicepresident coach human_resources system_manager].include? position
  end

  def leader?
    position == "leader"
    # Project.exists?(manager_id: id)
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
end
