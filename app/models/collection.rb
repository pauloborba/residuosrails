class Collection < ApplicationRecord
  has_many :residues
  has_many :reports, dependent: :destroy
  has_one :notification, dependent: :destroy
  
  validates :max_value, presence: true
  
  attr_accessor :porcent
  attr_accessor :mean, :miss_days, :miss_weight, :solido_organico, :solido_inorganico, :liquido_organico, :liquido_inorganico, :liquido_inflamavel, :outros
  attr_accessor :solido_organico_percent, :solido_inorganico_percent, :liquido_organico_percent, :liquido_inorganico_percent, :liquido_inflamavel_percent, :outros_percent
  attr_accessor :residue_often_registered_list, :residue_often_registered_number
  attr_accessor :dep_residue_list, :dep_residue_weight, :dep_mean
  attr_accessor :solido_organico_mean, :solido_inorganico_mean, :liquido_organico_mean, :liquido_inorganico_mean, :liquido_inflamavel_mean, :outros_mean
  
  def generate_prediction
    @mean = calc_mean
    @miss_weight = calc_miss_weight
    @miss_days = calc_miss_days
  end
  
  def total_weight
    weight = 0.0
    Residue.all.each do |residue|
      weight += residue.weight
    end
    return weight
  end
  
  def calc_mean
    time = Date.today - Collection.last.created_at.to_date
    mean = self.total_weight/time
    return mean
  end
  
  def calc_miss_weight
    miss_weight = (Collection.last.max_value - self.total_weight)
    return miss_weight
  end
  
  def calc_miss_days()
    miss_days = @miss_weight/@mean
    miss_days = miss_days.ceil
    return miss_days
  end
  
  def type_residue
    @solido_organico = 0.0
    @solido_inorganico = 0.0
    @liquido_organico = 0.0
    @liquido_inorganico = 0.0
    @liquido_inflamavel = 0.0
    @outros  = 0.0
    Residue.all.each do |residue|
      case residue.kind
      when "Sólido Orgânico"
        @solido_organico += residue.weight
      when "Sólido Inorgânico"
        @solido_inorganico += residue.weight
      when "Líquido Orgânico"
        @liquido_organico += residue.weight
      when "Líquido Inorgânico"
        @liquido_inorganico += residue.weight
      when "Líquido Inflamável"
        @liquido_inflamavel += residue.weight
      when "Outros"
        @outros += residue.weight
      end
    end
  end
  
  def type_residue_percent
    self.type_residue
    weight = self.total_weight
    @solido_organico_percent = ((@solido_organico/weight)*1000).round/10.0
    @solido_inorganico_percent = ((@solido_inorganico/weight)*1000).round/10.0
    @liquido_organico_percent = ((@liquido_organico/weight)*1000).round/10.0
    @liquido_inorganico_percent = ((@liquido_inorganico/weight)*1000).round/10.0
    @liquido_inflamavel_percent = ((@liquido_inflamavel/weight)*1000).round/10.0
    @outros_percent = ((@outros/weight)*1000).round/10.0
  end
  
  def residue_often_registered
    @residue_often_registered_list = Hash.new
    @residue_often_registered_number = Hash.new(0)
    Residue.all.order(:created_at).each do |residue|
      lab = Laboratory.find_by(id: residue.laboratory_id)
      if residue.number_registers >= @residue_often_registered_number[lab.name.parameterize.underscore.to_sym]
        @residue_often_registered_number[lab.name.parameterize.underscore.to_sym] = residue.number_registers
        @residue_often_registered_list[lab.name.parameterize.underscore.to_sym] = residue.name
      elsif residue.number_registers == 0
      elsif residue.number_registers == @residue_often_registered_number[lab.name.parameterize.underscore.to_sym]
        @residue_often_registered_list[lab.name.parameterize.underscore.to_sym] += ", "+residue.name
      end
    end
  end
  
  def dep_residue
    @dep_residue_list = Hash.new
    @dep_residue_weight = Hash.new(0)
    @dep_residue_qntd = Hash.new(0)
    Department.all.each do |dept|
      @dep_residue_list[dept.name.parameterize.underscore.to_sym] = dept.name
      Residue.all.each do |residue|
        lab = Laboratory.find_by(id: residue.laboratory_id)
        if lab.department_id == dept.id
          @dep_residue_weight[dept.name.parameterize.underscore.to_sym] += residue.weight
          @dep_residue_qntd[dept.name.parameterize.underscore.to_sym] += 1
        end
      end
    end
  end
  
  def generate_mean_type
    @solido_organico = 0.0
    @solido_organico_qntd = 0
    @solido_inorganico = 0.0
    @solido_inorganico_qntd = 0
    @liquido_organico = 0.0
    @liquido_organico_qntd = 0
    @liquido_inorganico = 0.0
    @liquido_inorganico_qntd = 0
    @liquido_inflamavel = 0.0
    @liquido_inflamavel_qntd = 0
    @outros = 0.0
    @outros_qntd = 0
    Residue.all.each do |residue|
      case residue.kind
      when "Sólido Orgânico"
        @solido_organico += residue.weight
        @solido_organico_qntd += 1
      when "Sólido Inorgânico"
        @solido_inorganico += residue.weight
        @solido_inorganico_qntd += 1
      when "Líquido Orgânico"
        @liquido_organico += residue.weight
        @liquido_organico_qntd += 1
      when "Líquido Inorgânico"
        @liquido_inorganico += residue.weight
        @liquido_inorganico_qntd += 1
      when "Líquido Inflamável"
        @liquido_inflamavel += residue.weight
        @liquido_inflamavel_qntd += 1
      when "Outros"
        @outros += residue.weight
        @outros_qntd += 1
      end
    end
    
    calc_mean_type
  end
  
  def calc_mean_type
    @solido_organico_mean = @solido_organico/@solido_organico_qntd
    @solido_inorganico_mean = @solido_inorganico/@solido_inorganico_qntd
    @liquido_organico_mean = @liquido_organico/@liquido_organico_qntd
    @liquido_inorganico_mean = @liquido_inorganico/@liquido_inorganico_qntd
    @liquido_inflamavel_mean = @liquido_inflamavel/@liquido_inflamavel_qntd
    @outros_mean  = @outros/@outros_qntd
  end
  
  def calc_mean_dep
    @dep_mean = Hash.new
    dep_residue
    Department.all.each do |dep|
      weight = @dep_residue_weight[dep.name.parameterize.underscore.to_sym]
      qntd = @dep_residue_qntd[dep.name.parameterize.underscore.to_sym]
      @dep_mean[dep.name.parameterize.underscore.to_sym] = weight/qntd
    end
  end
  
  def calc_days
    days_collect = Collection.last.created_at.to_date - 10
    return days_collect
  def generate_notification
    total_weight = 0
    col = Collection.last
    col.porcent = 0.93333333
    
    Residue.all.each do |res|
      total_weight += res.registers.where(created_at: [col.created_at..Time.now]).sum(:weight)
    end
    
    if total_weight > col.max_value
      if(col.notification != nil)
        notif = Notification.find_by(collection_id: col.id)
        notif.destroy
      end
      notif = Notification.create(message: "Passou do peso limite, deve fazer uma licitação", collection_id: col.id)
      
      
    elsif total_weight > (col.max_value*col.porcent)
      if(col.notification != nil)
        notif = Notification.find_by(collection_id: col.id)
        notif.destroy
      end
      Notification.create(message: "O peso está próximo do peso mínimo para fazer uma licitação", collection_id: col.id)
      
    end
    
  end
end

end  