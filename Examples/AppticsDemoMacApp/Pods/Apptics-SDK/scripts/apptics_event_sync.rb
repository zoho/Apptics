begin
require 'xcodeproj'
require "json"
rescue LoadError => error
  puts "echo #{error.message}, check if commandline tools are installed"
  exit
end

class AppticsModerator
  
  $projectName # project name
  $targetName # target name
  $fileName = "AppticsExtension" #
  $eventClassName = "APEventExtension" #
  $apiClassName = "APAPIExtension" #
  $prefix="AP"
  $AppticsGroupName="Apptics"
  
  def self.add_group_to_project(main_group)
    name_of_generated_folder=$AppticsGroupName
    generated_group = main_group[name_of_generated_folder]
    unless generated_group
      generated_group = main_group.new_group(name_of_generated_folder)
    end
    return generated_group
  end
    
  def self.main(projectName, selectedTargetName, targetgroup, projectRootDir, lang, prefix, metafilename)
    $prefix=prefix
    $fileName=$prefix+$fileName
    $apiClassName=$prefix+$apiClassName
    data_hash = JSON.parse(File.read("/tmp/#{metafilename}"))
    
    if data_hash == nil || data_hash["result"] != "success"
      puts "Response : #{data_hash}"
      return false
      else
      data_hash=data_hash["data"]
    end    
    
    event_hash = data_hash["event"]
    api_hash = data_hash["api"]
        
    file_ext="h,m"
    if lang == "objc"
      objch_fc = "#import <Foundation/Foundation.h>\n"
      objch_fc.concat("#if __has_include(<Apptics/Apptics-umbrella.h>)\n")
      objch_fc.concat("@import Apptics;\n")
      objch_fc.concat("#elif __has_include(<Apptics/APEventsEnum.h>)\n")
      objch_fc.concat("#import <Apptics/APEventsEnum.h>\n")
      objch_fc.concat("#import <Apptics/Apptics.h>\n")
      objch_fc.concat("#import <Apptics/APBundle.h>\n")
      objch_fc.concat("#else\n")
      objch_fc.concat("#import \"APEventsEnum.h\"\n")
      objch_fc.concat("#import \"Apptics.h\"\n")
      objch_fc.concat("#import \"APBundle.h\"\n")
      objch_fc.concat("#endif\n")
      
      objch_fc.concat("#if __has_include(<AppticsEventTracker/Apptics-umbrella.h>)\n")
      objch_fc.concat("@import AppticsEventTracker;\n")
      objch_fc.concat("#elif __has_include(<AppticsEventTracker/AppticsEventTracker.h>)\n")
      objch_fc.concat("#import <AppticsEventTracker/APEvent.h>\n")
      objch_fc.concat("#else\n")
      objch_fc.concat("#import \"APEvent.h\"\n")
      objch_fc.concat("#endif\n")
      
      objch_fc.concat("typedef enum {\n")
      objch_fc.concat("\tAPEventTypeNone")
      
      objcm_fc = "#import \"#{$fileName}.h\"\n\n"
      
      objcm_fc_m0="@implementation APEvent (Extension)\n\n"
      
      objcm_fc_m01 = "+ (NSString*) group :(APEventType) type;{\n"
      
      objcm_fc_m01.concat("\tNSString *group;\n\n")
      objcm_fc_m01.concat("\tswitch (type) {\n")
            
      if event_hash != nil
          
          objcm_fc_m0.concat("+ (NSString*) event :(APEventType) type;{\n")
          objcm_fc_m0.concat("\tNSString *event;\n\n")
          objcm_fc_m0.concat("\tswitch (type) {\n")
          flag2 = false
          
          event_hash.map do | group, groupInfo|
              
            group = group.strip.gsub(/[^0-9A-Za-z]/, '_')
            groupID = groupInfo["groupid"]
            events = groupInfo["event"]
            flag2 = true
            events.map do | name, id |
                name = name.strip.gsub(/[^0-9A-Za-z]/, '_')
                
                objch_fc.concat(",\n\n\tAPEventType_#{group}_#{name}")
                objcm_fc_m0.concat("\t\tcase APEventType_#{group}_#{name}:\n")
                objcm_fc_m0.concat("\t\t\tevent=@\"#{name}\";\n")
                objcm_fc_m0.concat("\t\t\tbreak;\n")
                
                objcm_fc_m01.concat("\t\tcase APEventType_#{group}_#{name}:\n")
                objcm_fc_m01.concat("\t\t\tgroup=@\"#{group}\";\n")
                objcm_fc_m01.concat("\t\t\tbreak;\n")
                
            end
            
          end
      
      objcm_fc_m0.concat("\t\tcase APEventTypeNone:\n")
      objcm_fc_m0.concat("\t\t\tbreak;\n")
      objcm_fc_m0.concat("\t\tdefault:\n")
      objcm_fc_m0.concat("\t\t\tbreak;\n")
      objcm_fc_m0.concat("\t}\n")
      objcm_fc_m0.concat("\treturn event;\n}\n\n")
      
      objcm_fc_m01.concat("\t\tcase APEventTypeNone:\n")
      objcm_fc_m01.concat("\t\t\tbreak;\n")
      objcm_fc_m01.concat("\t\tdefault:\n")
      objcm_fc_m01.concat("\t\t\tbreak;\n")
      objcm_fc_m01.concat("\t}\n")
      objcm_fc_m01.concat("\treturn group;\n}\n\n")
      objcm_fc_m0.concat(objcm_fc_m01)
      
      objcm_fc_m0.concat("+ (void) trackEventWithType:(APEventType) type;{\n")
      objcm_fc_m0.concat("\t[self trackEventWithType:type andProperties:nil];\n}\n\n")
      
      objcm_fc_m0.concat("+ (void) trackEventWithType:(APEventType) type andProperties:(NSDictionary*_Nullable)props;{\n")
      objcm_fc_m0.concat("\tNSString *event = [self event:type];\n")
      objcm_fc_m0.concat("\tNSString *group = [self group:type];\n")
      objcm_fc_m0.concat("\t[APEvent trackEvent:event andGroupName:group withProperties:props];\n}\n\n")
      
      objcm_fc_m0.concat("+ (void) startTimedEventWithType:(APEventType) type;{\n")
      objcm_fc_m0.concat("\t[self startTimedEventWithType:type andProperties:nil];\n}\n\n")
      
      objcm_fc_m0.concat("+ (void) startTimedEventWithType:(APEventType) type andProperties:(NSDictionary * _Nullable)props;{\n")
      objcm_fc_m0.concat("\tNSString *event = [self event:type];\n")
      objcm_fc_m0.concat("\tNSString *group = [self group:type];\n")
      objcm_fc_m0.concat("\t[APEvent startTimedEvent:event group:group andProperties:props];\n}\n\n")
      
      objcm_fc_m0.concat("+ (void) endTimedEventWithType:(APEventType) type;{\n")
      objcm_fc_m0.concat("\tNSString *event = [self event:type];\n")
      objcm_fc_m0.concat("\t[APEvent endTimedEvent:event];\n}\n\n")
      
      end
                  
      objcm_fc_m0.concat("@end\n\n")
     
      objcm_fc.concat(objcm_fc_m0)
      objch_fc.concat("\n\n}APEventType;\n\n")
            
      objch_fc.concat("@interface APEvent(Extension)\n\n")
      
      if event_hash != nil
          
          objch_fc.concat("+ (NSString*_Nullable) event :(APEventType) type;\n\n")
          
          objch_fc.concat("+ (void) trackEventWithType:(APEventType) type;\n\n")
          
          objch_fc.concat("+ (void) trackEventWithType:(APEventType) type andProperties:(NSDictionary*_Nullable)props;\n\n")
          
          objch_fc.concat("+ (void) startTimedEventWithType:(APEventType) type;\n\n")
          
          objch_fc.concat("+ (void) startTimedEventWithType:(APEventType) type andProperties:(NSDictionary * _Nullable)props;\n\n")
          
          objch_fc.concat("+ (void) endTimedEventWithType:(APEventType) type;\n\n")
      end
            
      objch_fc.concat("@end\n\n")
             
      out_file = File.new("/tmp/#{$fileName}.h", "w")
      out_file.puts(objch_fc)
      out_file.close
      
      out_file = File.new("/tmp/#{$fileName}.m", "w")
      out_file.puts(objcm_fc)
      out_file.close
      else
      file_ext="swift"
      swiftc_fc = "#if canImport(Apptics)\n\timport Apptics\n#endif\n\n"
      swiftc_fc.concat("#if canImport(AppticsEventTracker)\n\timport AppticsEventTracker\n#endif\n\n")
      
      swiftc_fc_enum=""
      
      swiftc_fc_ap_ext="extension Apptics\n{\n"
      swiftc_fc_ap_ext.concat("\n}\n\n")
      
      swiftc_fc_ap_ext.concat("extension APEvent\n{\n")

      if event_hash != nil
          
          swiftc_fc_ap_ext_f0="\n\t@objc class func event(forType type : APEventType) -> String?{\n"
          swiftc_fc_ap_ext_f01="\t@objc class func group(forType type : APEventType) -> String?{\n"
          swiftc_fc_ap_ext_f1="\t@objc class public func trackEvent(withType type : APEventType, andProperties : [String : Any]?) {\n"
          swiftc_fc_ap_ext_f0.concat("\n\t\tvar event : String?\n")
          swiftc_fc_ap_ext_f0.concat("\t\tswitch (type) {\n")
          swiftc_fc_ap_ext_f01.concat("\n\t\tvar group : String?\n")
          swiftc_fc_ap_ext_f01.concat("\t\tswitch (type) {\n")
          
          swiftc_fc_ap_ext_f2="\t@objc class public func trackEvent(withType type : APEventType) {\n"
          swiftc_fc_ap_ext_f2.concat("\t\tself.trackEvent(withType: type, andProperties: nil)\n")
          
          swiftc_fc_ap_ext_f2.concat("\t}\n\n")
          flag2 = false
          
          swiftc_fc_enum.concat("@objc public enum APEventType : Int {\n")

          event_hash.map do | group, groupInfo|
            group = group.strip.gsub(/[^0-9A-Za-z]/, '_')
            groupID = groupInfo["groupid"]
            events = groupInfo["event"]
            flag2 = true
              events.map do | name, id|
                name = name.strip.gsub(/[^0-9A-Za-z]/, '_')
                
                swiftc_fc_enum.concat("    case _#{group}_#{name}\n")
                
                swiftc_fc_ap_ext_f0.concat("\t\tcase ._#{group}_#{name}:\n")
                swiftc_fc_ap_ext_f0.concat("\t\t\tevent=\"#{name}\"\n")
                swiftc_fc_ap_ext_f0.concat("\t\t\tbreak\n")
                
                swiftc_fc_ap_ext_f01.concat("\t\tcase ._#{group}_#{name}:\n")
                swiftc_fc_ap_ext_f01.concat("\t\t\tgroup=\"#{group}\"\n")
                swiftc_fc_ap_ext_f01.concat("\t\t\tbreak\n")
                
              end
           
          end
          swiftc_fc_enum.concat("\t\tcase None\n")
          swiftc_fc_enum.concat("}\n\n")
                  
      swiftc_fc_ap_ext_f0.concat("\t\tcase .None:\n")
      swiftc_fc_ap_ext_f0.concat("\t\t\tbreak\n")
      swiftc_fc_ap_ext_f0.concat("\t\t\tdefault: break\n")
      swiftc_fc_ap_ext_f0.concat("\t\t}\n")
      swiftc_fc_ap_ext_f0.concat("\t\treturn event\n\n")
      swiftc_fc_ap_ext_f0.concat("\t}\n\n")
      
      swiftc_fc_ap_ext_f01.concat("\t\tcase .None:\n")
      swiftc_fc_ap_ext_f01.concat("\t\t\tbreak\n")
      swiftc_fc_ap_ext_f01.concat("\t\t\tdefault: break\n")
      swiftc_fc_ap_ext_f01.concat("\t\t}\n")
      swiftc_fc_ap_ext_f01.concat("\t\treturn group\n\n")
      swiftc_fc_ap_ext_f01.concat("\t}\n\n")
      
      swiftc_fc_ap_ext_f1.concat("\t\tif let event = self.event(forType: type), let group = self.group(forType: type){\n")
      swiftc_fc_ap_ext_f1.concat("\t\tAPEvent.trackEvent(event, andGroupName: group, withProperties: andProperties ?? [:])\n")
      swiftc_fc_ap_ext_f1.concat("\t\t}\n")
      swiftc_fc_ap_ext_f1.concat("\t}\n\n")
      
      swiftc_fc.concat(swiftc_fc_enum)
      
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f0)
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f01)
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f1)
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f2)
      
      swiftc_fc_ap_ext_f3="\t@objc class public func startTimedEvent(withType type : APEventType, andProperties : [String : Any]?){\n"
      swiftc_fc_ap_ext_f3.concat("\t\tif let event = self.event(forType: type), let group = self.group(forType: type){\n")
      swiftc_fc_ap_ext_f3.concat("\t\tAPEvent.startTimedEvent(event, group: group, andProperties: andProperties ?? [:])\n")
      swiftc_fc_ap_ext_f3.concat("\t\t}\n")
      swiftc_fc_ap_ext_f3.concat("\t}\n\n")
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f3)
      
      
      swiftc_fc_ap_ext_f4="\t@objc class public func endTimedEvent(withType type : APEventType){\n"
      swiftc_fc_ap_ext_f4.concat("\t\tif let event = self.event(forType: type){\n")
      swiftc_fc_ap_ext_f4.concat("\t\tAPEvent.endTimedEvent(event)\n")
      swiftc_fc_ap_ext_f4.concat("\t\t}\n")
      swiftc_fc_ap_ext_f4.concat("\t}\n")
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f4)
      
      end
      
      swiftc_fc_ap_ext.concat("\n}\n\n")
      swiftc_fc.concat(swiftc_fc_ap_ext)
                  
      out_file = File.new("/tmp/#{$fileName}.swift", "w")
      out_file.puts(swiftc_fc)
      out_file.close
      
    end
    
    targetName=selectedTargetName
    destinationFileName=$fileName
    main_project_path = File.expand_path(projectName)
    project = Xcodeproj::Project.open(main_project_path)
    
        
        puts 'Project root : '+projectRootDir+'\n'
        
        target_group = project.main_group
        if target_group != nil
          if targetgroup == ""              
              apptics_group=add_group_to_project(target_group)
              project_path = projectRootDir
          else
            apptics_group=add_group_to_project(target_group[targetgroup])
            project_path = projectRootDir+"/"+targetgroup
          end
          
          file_ref = project_path
          files = []
          tmpDir = Dir["/tmp/#{$fileName}.{#{file_ext}}"]
          
          tmpDir.each do | filename|
            basename = File.basename(filename)
            file_ref = project_path + "/" + basename
            FileUtils.cp(filename, project_path, :verbose => true)
                                   
            if apptics_group.find_subpath(basename).nil?
              files.append(apptics_group.new_file(file_ref))
              puts 'Created file "'+filename+'" in "'+apptics_group.name+'"\n'
              else              
              files.append(apptics_group.find_subpath(basename))
              puts '\nUpdated file "'+filename+'" in "'+apptics_group.name+'"\n'
            end
                        
          end
          
          project.targets.each do |target|
            if !target.test_target_type?
              if target.name == targetName
                target.add_file_references(files)
              end
            end
          end
          
        end
        
        project.save(main_project_path)
        puts "Saving project "+main_project_path
    
  end
  
end

