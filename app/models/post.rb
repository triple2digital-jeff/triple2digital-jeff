# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  description :text
#  image_url   :string
#  is_hidden   :boolean          default(FALSE)
#  post_type   :string
#  privacy     :string
#  video_url   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_id   :integer
#  user_id     :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

class Post < ApplicationRecord


  default_scope {order("updated_at DESC")}

  ########### Associations ##############
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :report_posts, dependent: :destroy

  ############ Validations ##############
  # attr_acce?ssor :current_user_id
  # attr_accessor :current_user
  #
  # def is_favorited_by_user?(user=nil)
  #
  #   user ||= current_user.id
  #   # rest of your code
  #   user.id
  # end
  ############ Instance Methods ##############

  def comments_count
    comments.count
  end

  def likes_count
    post_likes.count
  end

  def shared_count
    Post.where('parent_id=?',self.id).length
  end

  def is_liked(userid)
    # byebug
    self.post_likes.find_by_liked_by_id(userid).present?
  end

  def get_parent_post
    my_post = self
    loop do
      parent_post = Post.find_by_id(my_post.parent_id)
      my_post = parent_post
      break parent_post unless parent_post.try(:parent_id).present?
    end
  end

  def shared_by_users
    users=[]
    Post.where('parent_id=?', self.id ).each do |post|
      users.push(post.user)
    end
    users
  end

  def liked_by_users
    users=[]
    self.post_likes.each do |post|
      users.push(post.liked_by)
    end
    users
  end

  def current_user_id
    return nil
  end

  def parent_user
    user={}
    user[:user]= get_parent_post.try(:user) || {}
    # get_parent_post.present? ? get_parent_post.try(:user) : []
  end

  ############ Class Methods ##############
  # def as_json(options={})
  #   opts = {
  #       # is_likedd: self.is_liked
  #   }
  #
  #   super(options.merge(opts))
  # end


  def as_json(options = {})
    json_to_return = super
    json_to_return[:is_liked] = is_liked(options[:include][:current_user_id]) if options[:include].present? && options[:include][:current_user_id].present?
    json_to_return[:has_connection] = self.user.has_connection(options[:include][:current_user_id]) if options[:include].present? && options[:include][:current_user_id].present? && self.user.present?

    return json_to_return
  end

  def self.filter_fields
    {
        id: 'ID',
        description: 'Description',
        post_type: 'Type',
        privacy: 'Privacy'
    }
  end
  ############ Private Methods ##############
end
