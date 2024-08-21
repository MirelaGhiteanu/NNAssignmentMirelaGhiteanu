/**
 * Created by Mirela on 8/20/2024.
 */
public class LeadTriggerHandler implements TriggerHandler{

    private boolean triggerIsExecuting;
    private integer triggerSize;
    public LeadTriggerHelper helper;
    public LeadTriggerHandler(Boolean triggerIsExecuting, Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new LeadTriggerHelper();
    }

    public void beforeInsert(List<Lead> newLeads) {
        helper.setLeadAddressInfo(newLeads, null);
    }
    public void beforeUpdate(List<Lead> oldLeads, List<Lead> newLeads, Map<Id, SObject> oldLeadMap, Map<Id, SObject> newLeadMap) {
        helper.setLeadAddressInfo(newLeads, oldLeadMap);

    }
    public void beforeDelete(List<Lead> oldLeads, Map<Id, SObject> oldLeadMap) {

    }
    public void afterInsert(List<Lead> newLeads, Map<Id, SObject> newLeadMap) {

    }
    public void afterUpdate(List<Lead> oldLeads, List<Lead> newLeads, Map<Id, SObject> oldLeadMap, Map<Id, SObject> newLeadMap) {

    }
    public void afterDelete(List<Lead> oldLeads, Map<Id, SObject> oldLeadMap) {

    }
    public void afterUndelete(List<Lead> newLeads, Map<Id, SObject> newLeadMap) {

    }
}