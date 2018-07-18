class Domain < ApplicationRecord
  acts_as_paranoid
  strip_attributes only: :name

  has_many :user_domains
  has_many :shop_domains
  has_many :product_domains
  has_many :users, through: :user_domains
  has_many :shops, through: :shop_domains
  has_many :products, through: :product_domains
  has_many :request_shop_domains
  has_many :orders
  has_many :shop_manager_domains, dependent: :destroy

  VALID_NAME_REGEX = /\A[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬ
    ẮẰẲẴẶẸẺẼỀẾỂưăạảấầẩẫậắằẳẵặẹẻẽềếểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴ
    ÝỶỸửữựỳýỵỷỹ]{1}[ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀẾỂ
    ưăạảấầẩẫậắằẳẵặẹẻẽềếểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳýỵỷỹ
    a-zA-Z0-9\-\_\ ]{0,}+\z/

  validates :name, presence: true, format: {with: VALID_NAME_REGEX}

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [:name, [:name, :id]]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed? || super
  end

  def owner? user
    self.owner == user
  end

  def manage_by? user
    users = User.of_ids self.user_domains.user_ids_by_domain(self)
    users.include? user
  end

  enum status: {professed: 1, secret: 2, default: 3}

  scope :by_creator, -> user_id{where owner: user_id}
  scope :member, -> user_id{where.not owner: user_id}
  scope :by_status, -> status {where status: status}
  scope :list_domain_by_ids, -> ids {where id: ids}
  scope :except_id, ->(id){where.not id: id}
end
