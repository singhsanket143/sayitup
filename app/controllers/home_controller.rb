class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index]

# FOR ALL USERS PAGE
  def users_list
    respond_to do |format|
      format.html {
        if params[:search]
          @users=User.where(name: params[:search]).paginate(:per_page => 20, :page => params[:page])
        else
          @users=User.all.order(:name).paginate(:per_page => 10, :page => params[:page])
        end
      }
      format.js {}
    end
  end

# FOR ALL QUESTIONS ACCORDING TO TAGS
  def index
    @questagfeed = []
    if params[:question_id]
      @question=Question.find(params[:id])
      @question.tag_list.each do |tag|
        @questagfeed += Question.tagged_with(tag)
      end
    elsif params[:tag]
      @trendtagusers = []
      @tre=Trend.where(name: params[:tag]).first
      @trendtagusers += @tre.followers(User)
    else
      @tftags=Question.tag_counts_on(:tags).order('count desc').limit(5)
      @tftags.each do |tag|
        @questagfeed += Question.tagged_with(tag)
      end
    end
    respond_to do |format|
      format.html {
        @question = Question.new
        if params[:tag]
          @trend=Trend.where(name: params[:tag]).first
          @feed = Question.tagged_with(params[:tag]).paginate(:per_page => 20, :page => params[:page])
        elsif params[:search]
          v=User.search(params[:search]).paginate(:per_page=>20, :page=> params[:page])
          if v== nil
            @feed=Question.search(params[:search]).paginate(:per_page => 20, :page => params[:page])
          else
            @users=User.search(params[:search]).paginate(:per_page => 20, :page => params[:page])
            @feed=Question.search(params[:search]).paginate(:per_page => 20, :page => params[:page])
          end
        else
          @feed=current_user.feed.paginate(:per_page => 7, :page => params[:page])
        end
      }
      format.js {}
    end
  end

  # FOR MAIN HOME PAGE
  def indexmain
    respond_to do |format|
      format.html {
        @question = Question.new
        if params[:tag]
          @feed = Question.tagged_with(params[:tag]).paginate(:per_page => 4, :page => params[:page])
        else
          @feed=Question.last(10).reverse
          @latestfeed=Question.last(10).reverse
          @tftags=Question.tag_counts_on(:tags).order('count desc').limit(5)
          @trendingfeed=[]
          @tftags.each do |tag|
            @trendingfeed += Question.tagged_with(tag)
          end
        end
      }
      format.js {}
    end
  end
  # FOR ALL TAGS
  def tags_list

  end
end
