require 'set'

$hash = {}
$id = ''
$main_field=''
$all_items = []
class PackHandler
    
    def identify(id)
        $id = id
    end

    def proc_items(items)

        if $id!='' && $id.class!=Symbol
            values = []
            items.each do |item|
                yield item 
                item.to_h
                item.each do |key, value|
                        if key == 'id' && (!values.include? value) && $hash["#{item}"] != "success"
                            values.push(value)
                            $hash["#{item}"] = "success"
                            procd_items(item)
                            puts $hash
                        end
                end
                
            end 
        elsif items.class == Array && $id.class!=Symbol
            items.each do |item|
                yield item 
                if item.class!=Integer
                item.each do |key,value|
                    if key.class == Symbol && value.class == Integer && $hash["#{item}"] != "success" && value%2==0
                        $hash["#{item}"] = "success"
                        procd_items(item)
                        puts $hash
                        elsif key.class != Symbol || value.class != Integer && $hash["#{item}"]!='success'
                            $hash["#{item}"] = 'success'
                            procd_items(item)
                            puts $hash
                    end
                end  
            else

                items.each do |item|
                    if $hash["#{item}"] != "success" && item.class!=Hash
                        $hash["#{item}"] = "success"
                        procd_items(item)
                        puts $hash
                    end 
                end

            end 
        end

        elsif $id.class==Symbol  #if array => object
            items.each do |item|
                if $hash["#{item.main_field}"] != "success"
                    $hash["#{item.main_field}"] = 'success'
                    procd_items(item.main_field)
                    puts $hash
                end
            end
        else

            items.each do |item|
            if $hash["#{item}"] != "success" && item.class!=Hash
                $hash["#{item}"] = "success"
                procd_items(item)
                puts $hash
            end 
        end

        end
        
    end




    def procd_items(item=nil) 
        if(item!=nil)
            $all_items.push(item)
        end
        $all_items.to_set
    end

    def should_proc(item=nil)
        if $id.class == Hash
            yield $id if block_given?
        end
        
    end

    def reset
    $hash = {}
    $id = ''
    end

   

end

packhandler = PackHandler.new

packhandler.proc_items([1,2,3,4]) do |item|
   puts item
end

packhandler.proc_items([3,4,5,6]) do |item|
    puts item
 end

packhandler.reset 

packhandler.proc_items([1,2,3,4]) do |item|
    puts item
 end

packhandler.proc_items([{'id'=>1},{'id'=>1,'test_key'=>'some_data'}]) do |item|
    puts item
end

packhandler.reset 

packhandler.identify('idfff')

packhandler.proc_items([{'id'=>1},{'id'=>1,'test_key'=>'some_data'},{'id'=>2}]) do |item|
   
end

packhandler.proc_items([{'id'=>2},{'id'=>3}]) do |item|
   puts item
end

packhandler.reset 

packhandler.proc_items([{value: 3},{value:2},{value:4}]) do |item|
    puts item
end

packhandler.proc_items([{value: 3},{value:2},{value:4},{value:6}]) do |item|
    puts item
end

class ClassName
    attr_reader :main_field
    def initialize(main_field)
    @main_field = main_field
    end
end

a = ClassName.new('a')
b = ClassName.new('b')

packhandler.identify(:main_field)

packhandler.proc_items([a,b]) do |item|
    puts item
end

packhandler.proc_items([ClassName.new('a')]) do |item|
    puts item
end

all = packhandler.procd_items

puts all

packhandler.identify(:value)

packhandler.should_proc do |item|
 item[:value]%2==0
end

