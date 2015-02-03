module HasOneTaskStep

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def has_one_task_step
      class_eval do
        has_one :task_step, as: :details, dependent: :destroy

        validates :task_step, presence: true

        delegate :completed_at, :completed?, :complete, to: :task_step
      end
    end
  end

end

ActiveRecord::Base.send :include, HasOneTaskStep
