class GossipsController < ApplicationController
  before_action :authenticate_user, only: [:index,:new,:create]
  layout "application", except: [:new, :create]

  def index

  end

  def show
    if params[:id].to_i <=0
      redirect_to "/gossips"
    end

  end

  def new
    @gossip = Gossip.new()
  end

  def create
    @gossip = Gossip.new('user_id' => current_user.id,'title' => params[:title],'content' => params[:content])

    if @gossip.save
      params[:tag].try(:each) do |i|
        @gossiptag = GossipTag.new('tag_id' => Tag.all.find(i).id,'gossip_id' => @gossip.id)
        @gossiptag.save
      end
      flash[:succes] = "Gossip crée avec succes"
      redirect_to "/gossips"
    else  
      render 'new'
    end
  end


  def edit
    @gossip = Gossip.new()
  end

  def update
      # Méthode qui met à jour le potin à partir du contenu du formulaire de edit.html.erb, soumis par l'utilisateur
      # pour info, le contenu de ce formulaire sera accessible dans le hash params
      # Une fois la modification faite, on redirige généralement vers la méthode show (pour afficher le potin modifié)

      @gossip = Gossip.find(id = params[:id].to_i)

      if @gossip.user_id == current_user.id
        if @gossip.update('user_id' => current_user.id,'title' => params[:title],'content' => params[:content])
          Gossip.order('id ASC')
          flash[:edit] = "Gossip modifié avec succes"
          redirect_to "/gossips"
        else
          render :edit
        end
      end
    end

    def destroy
      # Méthode qui récupère le potin concerné et le détruit en base
      @gossip = Gossip.find(id = params[:id].to_i)

      puts @gossip.user_id 
      puts current_user.id

      if @gossip.user_id == current_user.id

        @gossip.destroy
        flash[:delete] = "Gossip supprimé avec succes."
        redirect_to "/gossips"
        @@num2="1"
      else
        redirect_to "/gossips"
      end


    end


    private
    def current_user
    User.find_by(id: session[:user_id])
  end

   def log_in(user)
    session[:user_id] = user.id
   end

    def authenticate_user
      unless current_user
        flash[:danger] = "Please log in."
        redirect_to new_session_path
      end
    end

  end